import fs from 'fs';
import { KarabinerRules } from './types';
import { createLeaderSubLayers, app, open, shell } from './utils';

const rules: KarabinerRules[] = [
  ...createLeaderSubLayers({
    // b = 'B'rowse
    b: {
      c: open('https://calendar.google.com/'),
    },

    // o = 'Open' applications
    o: {
      c: app('calendar'),
      d: open('~/Downloads/'),
      f: app('firefox'),
      g: app('google chrome'),
      s: app('spotify'),
      t: app('ghostty'),
    },

    // w = 'Window'
    w: {
      // Using Rectangle keymap so I can switch to Raycast easily
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
      m: { description: 'Window: Forward', to: [{ key_code: 'close_bracket', modifiers: ['right_command'] }]},
    },

    // s = 'System'
    s: {
      u: { to: [{ key_code: 'volume_increment' }]},
      j: { to: [{ key_code: 'volume_decrement' }]},
      i: { to: [{ key_code: 'display_brightness_increment' }]},
      k: { to: [{ key_code: 'display_brightness_decrement' }]},
      l: { to: [{ key_code: 'q', modifiers: ['right_control', 'right_command'] }] },
      d: open('raycast://extensions/yakitrak/do-not-disturb/toggle?launchType=background'),
      t: open('raycast://extensions/raycast/system/toggle-system-appearance'), // [t]heme
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
      b: open('raycast://extensions/InteractiveNinja/linkding/search-bookmarks'),
      c: open('raycast://extensions/thomas/color-picker/pick-color'),
      // n: open('raycast://script-commands/dismiss-notifications'),
      e: open('raycast://extensions/raycast/emoji-symbols/search-emoji-symbols'),
      p: open('raycast://extensions/raycast/clipboard-history/clipboard-history'),
      q: open('raycast://extensions/gebeto/translate/quick-translate'),
      s: open('raycast://extensions/peduarte/silent-mention/index'),
      t: open('raycast://extensions/raycast/raycast/confetti'), // tada!
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
