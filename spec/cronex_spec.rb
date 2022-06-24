# frozen_string_literal: true

RSpec.describe Cronex do
  it "has a version number" do
    expect(Cronex::VERSION).not_to be nil
  end

  describe ".parse" do
    context "valid cron string" do
      it "parses cron string" do
        expect(described_class.parse("*/15 0 1,15 * 1-5 /usr/bin/find")).to eq <<~EOF
          minute        0 15 30 45
          hour          0
          day of month  1 15
          month         1 2 3 4 5 6 7 8 9 10 11 12
          day of week   1 2 3 4 5
          command       /usr/bin/find
        EOF
      end

      it "parses cron string" do
        expect(described_class.parse("0 12 * * * my_cmd")).to eq <<~EOF
          minute        0
          hour          12
          day of month  1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
          month         1 2 3 4 5 6 7 8 9 10 11 12
          day of week   1 2 3 4 5 6 7
          command       my_cmd
        EOF
      end

      it "parses cron string" do
        expect(described_class.parse("15 10 * * * my_cmd")).to eq <<~EOF
          minute        15
          hour          10
          day of month  1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
          month         1 2 3 4 5 6 7 8 9 10 11 12
          day of week   1 2 3 4 5 6 7
          command       my_cmd
        EOF
      end

      it "parses cron string" do
        expect(described_class.parse("* 14 * * * my_cmd")).to eq <<~EOF
          minute        0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59
          hour          14
          day of month  1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
          month         1 2 3 4 5 6 7 8 9 10 11 12
          day of week   1 2 3 4 5 6 7
          command       my_cmd
        EOF
      end

      it "parses cron string" do
        expect(described_class.parse("0/5 14 * * * my_cmd")).to eq <<~EOF
          minute        0 5 10 15 20 25 30 35 40 45 50 55
          hour          14
          day of month  1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
          month         1 2 3 4 5 6 7 8 9 10 11 12
          day of week   1 2 3 4 5 6 7
          command       my_cmd
        EOF
      end

      it "parses cron string" do
        expect(described_class.parse("0/5 14,18 * * * my_cmd")).to eq <<~EOF
          minute        0 5 10 15 20 25 30 35 40 45 50 55
          hour          14 18
          day of month  1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
          month         1 2 3 4 5 6 7 8 9 10 11 12
          day of week   1 2 3 4 5 6 7
          command       my_cmd
        EOF
      end

      it "parses cron string" do
        expect(described_class.parse("0-5 14 * * * my_cmd")).to eq <<~EOF
          minute        0 1 2 3 4 5
          hour          14
          day of month  1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
          month         1 2 3 4 5 6 7 8 9 10 11 12
          day of week   1 2 3 4 5 6 7
          command       my_cmd
        EOF
      end
    end

    context "invalid cron string" do
      it "raises ArgumentError" do
        expect { described_class.parse("15 */* * * * /usr/bin/find") }.to raise_error(
          ArgumentError, "Invalid expression */* for hour")
      end

      it "raises ArgumentError" do
        expect { described_class.parse("15 *-2 * * * /usr/bin/find") }.to raise_error(
          ArgumentError, "Invalid expression *-2 for hour")
      end

      it "raises ArgumentError" do
        expect { described_class.parse("15 1- * * * /usr/bin/find") }.to raise_error(
          ArgumentError, "Invalid expression 1- for hour")
      end

      it "raises ArgumentError" do
        expect { described_class.parse("30-12 * * * * /usr/bin/find") }.to raise_error(
          ArgumentError, "Invalid expression 30-12 for minute")
      end
    end
  end
end
