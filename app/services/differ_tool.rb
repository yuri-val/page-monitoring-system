# require 'differ'
# require 'differ/string'

class DifferTool
  attr_reader :current, :original, :diff, :text, :fmt, :diff_by, :error

  def initialize(c_v, o_v, options = {})
    @current  = Version.find(c_v)
    @original = Version.find(o_v)
    @text     = (options[:text]    || :plain_text).to_sym
    @fmt      = (options[:format]  || :array).to_sym
    @diff_by  = (options[:diff_by] || :word).to_sym
    set_diff
  end

  private

  def set_diff
    @diff = begin
              @error = false
              raise if @current.nil? || @original.nil?

              if @fmt == :array
                Diff::LCS.diff(@current[@text].split(' '), @original[@text].split(' '))
              else
                Differ.format = @fmt
                Differ.send("diff_by_#{diff_by}", @current[@text], @original[@text]).to_s.html_safe
              end
            rescue Exception => msg
              @error = true
              msg.to_s + "
              \n Check your vrsion id's
              \n OR
              \n Check your parametest: [url]?par1=val1[&par2=val2]
              \n Parameter: {Value1|Value2}
              \n text: {plain_text|html_text} default:plain_text
              \n format: {ascii|color|html} default:html
              \n diff_by: {line|word|char} default:word
              \n type: {html|json} default:json"
            end
  end
end
