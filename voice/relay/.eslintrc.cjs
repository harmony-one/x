module.exports = {
  root: true,
  env: {
    node: true,
    es2020: true,
  },
  extends: [
    'standard-with-typescript',
  ],
  parser: '@typescript-eslint/parser',
  rules: {
    '@typescript-eslint/strict-boolean-expressions': 0,
    'no-await-in-loop': 0,
    'no-underscore-dangle': 0,
    'import/prefer-default-export': 0,
    'import/no-extraneous-dependencies': 1,
    'comma-dangle': 0,
    'no-console': 0,
    'no-mixed-operators': 0,
    'new-cap': 0,
    'max-len': 0,
    'promise/always-return': 'off',
    'import/no-cycle': 'off',
    'no-shadow': 'off',
    '@typescript-eslint/no-shadow': 'off',
    'import/extensions': 'off',
    'object-curly-newline': ['error', { multiline: true }],
    '@typescript-eslint/restrict-template-expressions': 0,
    '@typescript-eslint/no-misused-promises': 0
  },
  parserOptions: {
    ecmaVersion: 2020,
    sourceType: 'module',
    project: './tsconfig.json',
    tsconfigRootDir: __dirname,
    createDefaultProgram: true,
  },
  settings: { 'import/parsers': { '@typescript-eslint/parser': ['.ts', '.tsx'] }, },
}
