# frozen_string_literal: true

require "spec_helper"

RSpec.describe "CLI", type: :aruba do
  context "usage instructions" do
    before do
      run_command "cronex --help"
    end

    it "displays usage instructions" do
      expect(last_command_started).to be_successfully_executed
      expect(last_command_started).to have_output <<~EOF.chomp
        Usage:   cronex [cron_string]
        Example: cronex "*/15 0 1,15 * 1-5 /usr/bin/find"
      EOF
    end
  end

  context "parse cron string" do
    context "valid string" do
      before do
        run_command 'cronex "*/15 0 1,15 * 1-5 /usr/bin/find"'
      end

      it "displays usage instructions" do
        expect(last_command_started).to be_successfully_executed
        expect(last_command_started).to have_output <<~EOF.chomp
          minute        0 15 30 45
          hour          0
          day of month  1 15
          month         1 2 3 4 5 6 7 8 9 10 11 12
          day of week   1 2 3 4 5
          command       /usr/bin/find
        EOF
      end
    end

    context "invalid string" do
      before do
        run_command 'cronex "15 *-1 * * * /usr/bin/find"'
      end

      it "displays usage instructions" do
        expect(last_command_started).to have_exit_status(1)
        expect(last_command_started).to have_output <<~EOF.chomp
          ** Error occurred: Invalid expression *-1 for hour. Get help: cronex --help
        EOF
      end
    end
  end
end
