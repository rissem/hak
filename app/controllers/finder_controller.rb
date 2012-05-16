class FinderController < ApplicationController
  def index
  end

  def search
    response = {}
    
    extensions = FILE_EXTENSIONS.split(",")
    find_command = "find #{PROJECT_DIRECTORY} -name \"*#{extensions[0]}\""
    extensions.slice(1..-1).each {|extension| find_command += " -or -name \"*#{extension}\""}
    find_command += " | xargs grep -niC5 #{params[:text]}"
    results = `#{find_command}`

    results.split("\n").slice(0..500).each do |line|
      matches = /(.*?)[-:](\d+)[-:]\s+(.*)/.match(line)
      if not matches
        next
        Rails.logger.info "skipping line #{line}"
      end
      filename = matches[1]
      line_num = matches[2].to_i
      code = matches[3]
      code.gsub!(params[:text], "<strong id='strong'>#{params[:text]}</strong>")

      code.gsub!("  ", "&nbsp;&nbsp;")
      response[filename] = [] unless response[filename]
      response[filename] = response[filename].push({line: code, line_num: line_num})
    end
    render :json => response
  end

  def open
    if /mate$/.match(EDITOR)
      `#{EDITOR} -l #{params[:line]} #{params[:file]}`
      Rails.logger.info("opening file in textmate")
    elsif /emacsclient$/.match(EDITOR)
      `#{EDITOR} -n +#{params[:line]} #{params[:file]}`
      Rails.logger.info("opening file in emacs #{params}")
    end
	render :json => {}
  end
end
