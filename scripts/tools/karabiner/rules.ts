import fs from 'fs';
import { KarabinerRules } from './types';
import { createLeaderSubLayers, app, open, shell } from './utils';

const rules: KarabinerRules[] = [
  ...createLeaderSubLayers({

    b: {
      description: '[B]rowser',

      c: open('https://calendar.google.com/'),
    },

    o: {
      description: '[O]pen',

      c: app('calendar'),
      d: open('~/Downloads/'),
      f: app('firefox'),
      g: app('google chrome'),
      s: app('spotify'),
      t: app('ghostty'),
    },

    w: {
      description: '[W]indow',

      // Using Rectangle keymap so I can switch to Raycast easily
      y: { description: 'Previous Display', to:[{ key_code: 'left_arrow', modifiers:['left_control', 'left_option', 'left_command'] }]},
      o: { description: 'Next Display', to:[{ key_code: 'right_arrow', modifiers:['left_control', 'left_option', 'left_command'] }]},
      k: { description: 'Top Half', to:[{ key_code: 'up_arrow', modifiers:['left_control', 'left_option'] }]},
      j: { description: 'Bottom Half', to:[{ key_code: 'down_arrow', modifiers:['left_control', 'left_option'] }]},
      h: { description: 'Left Half', to:[{ key_code: 'left_arrow', modifiers:['left_control', 'left_option'] }]},
      l: { description: 'Right Half', to:[{ key_code: 'right_arrow', modifiers:['left_control', 'left_option'] }]},
      close_bracket: { description: 'Maximize', to:[{ key_code: 'return_or_enter', modifiers:['left_control', 'left_option'] }]},
      open_bracket: { description: 'Almost Maximize', to:[{ key_code: 'return_or_enter', modifiers:['left_control', 'left_option', 'left_command'] }]},

      u: { description: 'Window: Previous Tab', to: [{ key_code: 'tab', modifiers: ['right_control', 'right_shift'] }] },
      i: { description: 'Window: Next Tab', to: [{ key_code: 'tab', modifiers: ['right_control'] }]},

      n: { description: 'Window: Next Window', to: [{ key_code: 'grave_accent_and_tilde', modifiers: ['right_command'] }]},

      b: { description: 'Window: Back', to: [{ key_code: 'open_bracket', modifiers: ['right_command'] }]},
      m: { description: 'Window: Forward', to: [{ key_code: 'close_bracket', modifiers: ['right_command'] }]},
    },

    s: {
      description: '[S]ystem',

      u: {  description: 'Volume: Up', to: [{ key_code: 'volume_increment' }]},
      j: {  description: 'Volume: Down', to: [{ key_code: 'volume_decrement' }]},
      i: {  description: 'Brightness Increase', to: [{ key_code: 'display_brightness_increment' }]},
      k: {  description: 'Brightness Decrease', to: [{ key_code: 'display_brightness_decrement' }]},
      l: {  description: 'Lock Screen', to: [{ key_code: 'q', modifiers: ['right_control', 'right_command'] }] },
      d: open('raycast://extensions/yakitrak/do-not-disturb/toggle?launchType=background'),
      t: open('raycast://extensions/raycast/system/toggle-system-appearance'), // [t]heme
      c: open('raycast://extensions/raycast/system/open-camera'),
    },

    c: {
      description: 'Musi[c]',

      p: { description: 'Play/Pause', to: [{ key_code: 'play_or_pause' }]},
      n: { description: 'Next', to: [{ key_code: 'fastforward' }]},
      b: { description: 'Previous', to: [{ key_code: 'rewind' }]},
    },

    r: {
      description: '[R]aycast',

      b: open('raycast://extensions/InteractiveNinja/linkding/search-bookmarks'),
      c: open('raycast://extensions/thomas/color-picker/pick-color'),
      d: open('raycast://extensions/raycast/dictionary/define-word'),
      // n: open('raycast://script-commands/dismiss-notifications'),
      e: open('raycast://extensions/raycast/emoji-symbols/search-emoji-symbols'),
      p: open('raycast://extensions/raycast/clipboard-history/clipboard-history'),
      q: open('raycast://extensions/gebeto/translate/quick-translate'),
      s: open('raycast://extensions/peduarte/silent-mention/index'),
      t: open('raycast://extensions/raycast/raycast/confetti'), // tada!
      l: open('raycast://extensions/raycast/raycast/search-quicklinks'),
    },
    semicolon: open('raycast://extensions/raycast/emoji-symbols/search-emoji-symbols'),
    v: open('raycast://extensions/raycast/clipboard-history/clipboard-history'),

    n: {
      description: '[N]otes',

      b: open('obsidian://adv-uri?vault=notes&commandid=quickadd%3Achoice%3A91c007f6-e99e-42b3-be88-b4e197515eec'),
      w: open('obsidian://adv-uri?vault=notes&commandid=calendar%3Aopen-weekly-note'),
    },
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
