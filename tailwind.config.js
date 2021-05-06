module.exports = {
  // purge: {
  //   content: ["./app/**/*.html.erb", "./app/components/*", "./app/helpers/*"],
  // },
  darkMode: false,
  theme: {
    extend: {
      margin: {
        "0.25": "0.0625rem"
      }
    },
    rotate: {
      '-180': '-180deg',
      '-135': '-135deg',
       '-90': '-90deg',
      '-45': '-45deg',
       '0': '0',
       '45': '45deg',
       '90': '90deg',
      '135': '135deg',
       '180': '180deg',
      '270': '270deg',
     }
  },
  variants: {
    extend: {},
  },
  plugins: [require("@tailwindcss/forms")],
};
