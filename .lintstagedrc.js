const path = require('path')

const buildEslintCommand = (filenames) =>
  `next lint --fix --file ${filenames
    .map((f) => path.relative(process.cwd(), f))
    .join(' --file ')}`

const buildBackendEslintCommand = (filenames) =>
  `cd backend && npx eslint --fix ${filenames
    .map((f) => path.relative(path.join(process.cwd(), 'backend'), f))
    .join(' ')}`

module.exports = {
  // Backend TypeScript/JavaScript files
  'backend/**/*.{ts,js}': [
    buildBackendEslintCommand,
    'cd backend && npx prettier --write',
    () => 'cd backend && npx tsc --noEmit'
  ],
  
  // Frontend TypeScript/JavaScript files
  'frontend/**/*.{ts,tsx,js,jsx}': [
    (filenames) => {
      const relativePaths = filenames.map(f => path.relative(path.join(process.cwd(), 'frontend'), f))
      return `cd frontend && ${buildEslintCommand(relativePaths)}`
    },
    'cd frontend && npx prettier --write',
    () => 'cd frontend && npx tsc --noEmit'
  ],
  
  // Mobile Dart files
  'mobile/**/*.dart': [
    () => 'cd mobile && flutter analyze',
    () => 'cd mobile && dart format .'
  ],
  
  // Configuration and documentation files
  '*.{json,md,yml,yaml}': [
    'prettier --write'
  ]
}
