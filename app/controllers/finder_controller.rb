class FinderController < ApplicationController
  def index
  end

  def search
    response = {}
    results = `find /Users/mike/web_frontend -name "*rb" | xargs grep -niC5 #{params[:text]}`

    results.split("\n").slice(0..300).each do |line|
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
    `/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -n +#{params[:line]} #{params[:file]}`
    Rails.logger.info("opening file in emacs #{params}")
	render :json => {}
  end
end
