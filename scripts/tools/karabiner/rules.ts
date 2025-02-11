import fs from 'fs';
import { KarabinerRules } from './types';
import { createLeaderSubLayers, app, open, shell } from './utils';

const rules: KarabinerRules[] = [
  // Define the Leader key itself
  {
    description: 'Tab → Leader Key (Tab if alone)',
    manipulators: [
      {
        from: { key_code: 'tab' },
        to: [{ set_variable: { name: 'leader', value: 1 }}],
        to_after_key_up: [{ set_variable: { name: 'leader', value: 0 }}],
        to_if_alone: [{ key_code: 'tab' }],
        type: 'basic',
      }
    ],
  },
  ...createLeaderSubLayers({
    // b = 'B'rowse
    b: {
      y: open('https://news.ycombinator.com'),
    },

    // o = 'Open' applications
    o: {
      c: app('calendar'),
      f: app('firefox'),
      g: app('google chrome'),
      s: app('spotify'),
      t: app('ghostty'),
    },

    // w = 'Window'
    w: {
      y: { description: 'Previous Display', to:[{ key_code: 'left_arrow', modifiers:['left_control', 'left_option', 'left_command'] }]},
      o: { description: 'Next Display', to:[{ key_code: 'right_arrow', modifiers:['left_control', 'left_option', 'left_command'] }]},
      k: { description: 'Top Half', to:[{ key_code: 'up_arrow', modifiers:['left_control', 'left_option'] }]},
      j: { description: 'Bottom Half', to:[{ key_code: 'down_arrow', modifiers:['left_control', 'left_option'] }]},
      h: { description: 'Left Half', to:[{ key_code: 'left_arrow', modifiers:['left_control', 'left_option'] }]},
      l: { description: 'Right Half', to:[{ key_code: 'right_arrow', modifiers:['left_control', 'left_option'] }]},
      f: { description: 'Maximize', to:[{ key_code: 'return_or_enter', modifiers:['left_control', 'left_option'] }]},
      g: { description: 'Almost Maximize', to:[{ key_code: 'return_or_enter', modifiers:['left_control', 'left_option', 'left_command'] }]},
      u: { description: 'Window: Previous Tab', to: [{ key_code: 'tab', modifiers: ['right_control', 'right_shift'] }] },
      i: { description: 'Window: Next Tab', to: [{ key_code: 'tab', modifiers: ['right_control'] }]},
      n: { description: 'Window: Next Window', to: [{ key_code: 'grave_accent_and_tilde', modifiers: ['right_command'] }]},
      b: { description: 'Window: Back', to: [{ key_code: 'open_bracket', modifiers: ['right_command'] }]},
      // Note: No literal connection. Both f and n are already taken.
      m: { description: 'Window: Forward', to: [{ key_code: 'close_bracket', modifiers: ['right_command'] }]},
    },

    // s = 'System'
    s: {
      u: { to: [{ key_code: 'volume_increment' }]},
      j: { to: [{ key_code: 'volume_decrement' }]},
      i: { to: [{ key_code: 'display_brightness_increment' }]},
      k: { to: [{ key_code: 'display_brightness_decrement' }]},
      l: { to: [{ key_code: 'q', modifiers: ['right_control', 'right_command'] }] },
      p: { to: [{ key_code: 'play_or_pause' }]},
      semicolon: { to: [{ key_code: 'fastforward' }]},
      d: open('raycast://extensions/yakitrak/do-not-disturb/toggle?launchType=background'),
      // 'T'heme
      t: open('raycast://extensions/raycast/system/toggle-system-appearance'),
      c: open('raycast://extensions/raycast/system/open-camera'),
    },

    // c = Musi*c* which isn't 'm' because we want it to be on the left hand
    c: {
      p: { to: [{ key_code: 'play_or_pause' }]},
      n: { to: [{ key_code: 'fastforward' }]},
      b: { to: [{ key_code: 'rewind' }]},
    },

    // r = 'Raycast'
    r: {
      c: open('raycast://extensions/thomas/color-picker/pick-color'),
      n: open('raycast://script-commands/dismiss-notifications'),
      e: open('raycast://extensions/raycast/emoji-symbols/search-emoji-symbols'),
      p: open('raycast://extensions/raycast/raycast/confetti'),
      s: open('raycast://extensions/peduarte/silent-mention/index'),
      v: open('raycast://extensions/raycast/clipboard-history/clipboard-history'),
    },

    v: open('raycast://extensions/raycast/clipboard-history/clipboard-history'),
  }),
];

fs.writeFileSync(
  `${process.env.OH_MY_GIL_SH}/config/.config/karabiner/karabiner.json`,
  JSON.stringify(
    {
      // global: {
      //   show_in_menu_bar: false,
      // },
      profiles: [
        {
          name: 'Default',
          selected: true,
          simple_modifications: [
            {
              from: { key_code: 'caps_lock' },
              to: [{ key_code: 'left_control' }]
            },
            {
              from: { key_code: 'non_us_backslash' },
              to: [{ key_code: 'grave_accent_and_tilde' }]
            }
          ],
          virtual_hid_keyboard: {
            country_code: 0,
            keyboard_type_v2: 'ansi'
          },
          complex_modifications: {
            rules,
          },
        },
      ],
    },
    null,
    2
  )
);
