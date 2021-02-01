module.exports = {
  purge: {
    content: ["./app/**/*.html.erb", "./app/components/*", "./app/helpers/*"],
  },
  darkMode: false,
  theme: {
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [require("@tailwindcss/forms")],
};
