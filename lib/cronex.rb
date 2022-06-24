# frozen_string_literal: true

require_relative "cronex/version"

module Cronex
  extend self
  RANGE = { minute: 0..59, hour: 0..23, mday: 1..31, month: 1..12, wday: 1..7 }.freeze

  def parse(str)
    args = str.split(/\s+/, 6)
    raise ArgumentError, "Invalid cron string" unless args.size == 6
    minute, hour, mday, month, wday, command = args
    <<~EOF
      minute        #{parse_group(:minute, minute)}
      hour          #{parse_group(:hour, hour)}
      day of month  #{parse_group(:mday, mday)}
      month         #{parse_group(:month, month)}
      day of week   #{parse_group(:wday, wday)}
      command       #{command}
    EOF
  end

  private

  # , value list separator
  def parse_group(unit, str)
    str.split(",").map { parse_exp(unit, _1) }.reduce(:|).join(" ")
  end

  def parse_exp(unit, exp_str)
    exp = tokenize(exp_str)
    exp.one? ? eval_single_exp(unit, *exp) : eval_operation_exp(unit, *exp)
  rescue ArgumentError
    raise ArgumentError, "Invalid expression #{exp_str} for #{unit}"
  end

  def eval_single_exp(unit, x)
    return RANGE[unit].to_a if x == :*
    raise ArgumentError unless x.is_a?(Integer) && RANGE[unit].include?(x)
    [x]
  end

  # * any value
  # - range of values
  # / step values
  def eval_operation_exp(unit, x, op, y)
    raise ArgumentError if !((x == :* || x.is_a?(Integer)) && %i[- /].include?(op) && y.is_a?(Integer)) || x == :* && op == :-
    return RANGE[unit].step(y).to_a if x == :*
    if op == :/
      raise ArgumentError unless RANGE[unit].include?(x)
      return (x..RANGE[unit].end).step(y).to_a
    end
    raise ArgumentError unless RANGE[unit].include?(x) && RANGE[unit].include?(y) && x <= y
    (x..y).to_a
  end

  def tokenize(exp)
    exp.each_char.with_object([]) do |c, res|
      if ('0'..'9').include?(c)
        x = c.to_i
        res[-1].is_a?(Integer) ? res[-1] = res[-1] * 10 + x : res << x
      else
        res << c.to_sym
      end
    end
  end
end
