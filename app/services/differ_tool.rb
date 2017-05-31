# require 'differ'
# require 'differ/string'

class DifferTool
  attr_reader :current, :original, :diff, :text, :fmt, :diff_by

  def initialize(c_v, o_v, options = {})
    @current  = Version.find(c_v)
    @original = Version.find(o_v)
    @text     = (options[:text]    || :plain_text).to_sym
    @fmt      = (options[:format]  || :html).to_sym
    @diff_by  = (options[:diff_by] || :by_word).to_sym
    set_diff
  end

  private
    def set_diff
      Differ.format = @fmt
      @diff = begin
                Differ.send("diff_#{diff_by}", @current[@text], @original[@text]).to_s.html_safe
              rescue Exception => msg
                msg.to_s
              end
    end


end
