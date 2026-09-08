import type { Config } from 'tailwindcss'

export default {
  content: [
    './app/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        // map to CSS variables where possible
        // (custom terminal colors are handled in global CSS)
      },
    },
  },
  plugins: [],
} satisfies Config
