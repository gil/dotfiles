import { To, KeyCode, Manipulator, KarabinerRules } from "./types";

/**
 * Custom way to describe a command in a layer
 */
export interface LayerCommand {
  to: To[];
  description?: string;
}

type LeaderKeySublayer = {
  // The ? is necessary, otherwise we'd have to define something for _every_ key code
  [key_code in KeyCode]?: LayerCommand;
};

/**
 * Create a Leader Key sublayer, where every command is prefixed with a key
 * e.g. Leader + O ("Open") is the "open applications" layer, I can press
 * e.g. Leader + O + G ("Google Chrome") to open Chrome
 */
export function createLeaderSubLayer(
  sublayer_key: KeyCode,
  commands: LeaderKeySublayer,
  allSubLayerVariables: string[]
): Manipulator[] {
  const subLayerVariableName = generateSubLayerVariableName(sublayer_key);

  // Add a help command
  const helpTitle = `${ commands["description"] || "" } commands:`;
  delete commands["description"];

  const help = Object.entries(commands)
    .map(([key, value]) => `${key}: ${value.description || "No description"}`);

  commands["slash"] = {
    description: "Help: Show Commands",
    to: [{
      shell_command: `osascript -e 'tell application "System Events" to display dialog "${ helpTitle }\n\n${ help.join("\n") }" with title "Help" buttons {"OK"}' default button 1`,
    }],
  };

  return [
    // When Leader + sublayer_key is pressed, set the variable to 1; on key_up, set it to 0 again
    {
      description: `Toggle Leader sublayer ${sublayer_key}`,
      type: "basic",
      from: {
        key_code: sublayer_key,
        modifiers: {
          optional: ["any"],
        },
      },
      to: [
        {
          set_variable: {
            name: subLayerVariableName,
            value: 1,
          },
        },
      ],
      // This enables us to press other sublayer keys in the current sublayer
      // (e.g. Leader + O > M even though Leader + M is also a sublayer)
      // basically, only trigger a sublayer if no other sublayer is active
      conditions: [
        ...allSubLayerVariables
          .filter(
            (subLayerVariable) => subLayerVariable !== subLayerVariableName
          )
          .map((subLayerVariable) => ({
            type: "variable_if" as const,
            name: subLayerVariable,
            value: 0,
          })),
        {
          type: "variable_if",
          name: "leader",
          value: 1,
        },
      ],
    },
    // Define the individual commands that are meant to trigger in the sublayer
    ...(Object.keys(commands) as (keyof typeof commands)[]).map(
      (command_key): Manipulator => ({
        ...commands[command_key],
        type: "basic" as const,
        from: {
          key_code: command_key,
          modifiers: {
            optional: ["any"],
          },
        },
        // Only trigger this command if the variable is 1 (i.e., if Leader + sublayer is held)
        conditions: [
          {
            type: "variable_if",
            name: subLayerVariableName,
            value: 1,
          },
        ],
      })
    ),
  ];
}

/**
 * Create all leader sublayers. This needs to be a single function, as well need to
 * have all the leader variable names in order to filter them and make sure only one
 * activates at a time
 */
export function createLeaderSubLayers(subLayers: {
  [key_code in KeyCode]?: LeaderKeySublayer | LayerCommand;
}): KarabinerRules[] {
  const allSubLayerVariables = (
    Object.keys(subLayers) as (keyof typeof subLayers)[]
  ).map((sublayer_key) => generateSubLayerVariableName(sublayer_key));

  // Add a help command
  const help = Object.entries(subLayers)
    .map(([key, value]) => `${key}: ${value.description! || "No description"}`);

  subLayers["slash"] = {
    description: "Help: Show Sublayers",
    to: [{
      shell_command: `osascript -e 'tell application "System Events" to display dialog "Sublayers:\n\n${ help.join("\n") }" with title "Help" buttons {"OK"}' default button 1`,
    }],
  };

  const sublayerRules: KarabinerRules[] = Object.entries(subLayers).map(([key, value]) =>
    "to" in value
      ? {
          description: `Leader Key + ${key}`,
          manipulators: [
            {
              ...value,
              type: "basic" as const,
              from: {
                key_code: key as KeyCode,
                modifiers: {
                  optional: ["any"],
                },
              },
              conditions: [
                {
                  type: "variable_if",
                  name: "leader",
                  value: 1,
                },
                ...allSubLayerVariables.map((subLayerVariable) => ({
                  type: "variable_if" as const,
                  name: subLayerVariable,
                  value: 0,
                })),
              ],
            },
          ],
        }
      : {
          description: `Leader Key sublayer "${key}"`,
          manipulators: createLeaderSubLayer(
            key as KeyCode,
            value,
            allSubLayerVariables
          ),
        }
  );

  return [
    // Define the Leader key itself
    {
      description: 'Tab → Leader Key (Tab if alone)',
      manipulators: [
        {
          from: { key_code: 'tab' },
          to: [{ set_variable: { name: 'leader', value: 1 }}],
          to_after_key_up: [
            { set_variable: { name: 'leader', value: 0 }},
            ...allSubLayerVariables.map((subLayerVariable) => ({
              set_variable: { name: subLayerVariable, value: 0 }
            })),
          ],
          to_if_alone: [{ key_code: 'tab' }],
          type: 'basic',
        }
      ],
    },
    ...sublayerRules,
  ];
}

function generateSubLayerVariableName(key: KeyCode) {
  return `leader_sublayer_${key}`;
}

/**
 * Shortcut for "open" shell command
 */
export function open(...what: string[]): LayerCommand {
  return {
    to: what.map((w) => ({
      shell_command: `open "${w}"`,
    })),
    description: `Open ${what.join(" & ")}`,
  };
}

/**
 * Utility function to create a LayerCommand from a tagged template literal
 * where each line is a shell command to be executed.
 */
export function shell(
  strings: TemplateStringsArray,
  ...values: any[]
): LayerCommand {
  const commands = strings.reduce((acc, str, i) => {
    const value = i < values.length ? values[i] : "";
    const lines = (str + value)
      .split("\n")
      .filter((line) => line.trim() !== "");
    acc.push(...lines);
    return acc;
  }, [] as string[]);

  return {
    to: commands.map((command) => ({
      shell_command: command.trim(),
    })),
    description: commands.join(" && "),
  };
}

/**
 * Shortcut for managing window sizing with Rectangle
 */
export function rectangle(name: string): LayerCommand {
  return {
    to: [
      {
        shell_command: `open -g rectangle://execute-action?name=${name}`,
      },
    ],
    description: `Window: ${name}`,
  };
}

/**
 * Shortcut for "Open an app" command (of which there are a bunch)
 */
export function app(name: string): LayerCommand {
  return open(`-a '${name}.app'`);
}
