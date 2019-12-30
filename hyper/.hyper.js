
module.exports = {
  config: {
    updateChannel: 'stable',

    fontSize: 12,
    fontFamily: '"DejaVuSansMono Nerd Font"',
    fontWeight: 'normal',
    fontWeightBold: 'normal',
    lineHeight: 1,
    letterSpacing: 0,

    cursorShape: 'BLOCK',
    cursorBlink: false,

    padding: '2px 6px',

    colors: {
      black: '#1d1d1d',         // base00
      red: '#cc6666',           // base08
      green: '#b5bd68',         // base0B
      yellow: '#f0c674',        // base0A
      blue: '#81a2be',          // base0D
      magenta: '#b294bb',       // base0E
      cyan: '#8abeb7',          // base0C
      white: '#bfd0d2',         // base05
      lightBlack: '#839496',    // base03
      lightRed: '#de935f',      // base09
      lightGreen: '#282a2e',    // base01
      lightYellow: '#373b41',   // base02
      lightBlue: '#b4b7b4',     // base04
      lightMagenta: '#9867aa',  // base0F
      lightCyan: '#fdf6e3',     // base06
      lightwhite: '#ffffff',    // base07
    },

      // black: '#2b2b2b',         // base00
      // red: '#cc6666',           // base08
      // green: '#b5bd68',         // base0B
      // yellow: '#f0c674',        // base0A
      // blue: '#81a2be',          // base0D
      // magenta: '#b294bb',       // base0E
      // cyan: '#8abeb7',          // base0C
      // white: '#bfd0d2',         // base05
      // lightBlack: '#657b83',    // base03
      // lightRed: '#de935f',      // base09
      // lightGreen: '#313335',    // base01
      // lightYellow: '#586e75',   // base02
      // lightBlue: '#93a1a1',     // base04
      // lightMagenta: '#9867aa',  // base0F
      // lightCyan: '#fdf6e3',     // base06
      // lightwhite: '#ffffff',    // base07

    foregroundColor: '#bfd0d2',
    backgroundColor: '#1d1d1d',
    selectionColor: '#8abeb7',
    borderColor: '#1d1d1d',
    cursorColor: '#bfd0d2',
    cursorAccentColor: '#1d1d1d',

    windowSize: [1860, 1120],
    showWindowControls: false,

    shellArgs: ['--login'],
    bell: 'false',

    modifierKeys: {
        altIsMeta: true
    }
  },

  keymaps: {
    'window:toggleFullScreen': 'shift+command+enter'
  },
};
