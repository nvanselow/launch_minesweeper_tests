# Test for Minesweeper Challenge (Launch Academy, Summer 2016)

This repository contains tests to help you complete the Minesweeper challenge.

## Instructions
1. Navigate to https://github.com/nvanselow/launch_minesweeper_tests
2. Click "Clone or Download" on the right side of the screen
3. Choose "Download Zip"
4. Unzip the files
5. Copy the `.rspec` and `Gemfile` into the folder with the minesweeper challenge
6. Copy the folder `spec` and all its contents into the folder with the minesweeper challenge
7. Navigate to your minesweeper challenge directory in the terminal
8. Run `bundle install` in the terminal
9. Run `rspec` in the terminal to run the tests.
10. Complete the challenge using Test-Driven Development!

*Optional:* You may want to add `--fail-fast` to the `.rspec` file to see
only one failing test at a time.

**Note:**
If the minesweeper board is opening when you run your tests, comment out lines
163 and 164 in `minesweeper.rb`.

**Note:**
Your final folder structure should look like this:

- minesweeper
  - `spec` [folder]
    - `cell_spec.rb`
    - `minefield_spec.rb`
    - `spec_helper.rb`
  - `.lesson.yml`
  - `.rspec`
  - `cell.rb`
  - `Gemfile`
  - `minefield.rb`
  - `minesweeper.md`
  - `minesweeper.rb`

## Heads up

1. I'm still new at testing, so these tests are provided as is. I hope you find them
helpful, but fair warning, they may lead you astray.
2. These tests are based on my solution to the minesweeper challenge. I'm sure there
are other ways to solve this challenge that may change the nature of the tests.
3. These tests may not demonstrate best testing practices (e.g., testing private methods);
however, those were included intentionally to help people move step-by-step through
solving the challenge.
4. If you have suggestions for improvement, DM me on the slack channel.
