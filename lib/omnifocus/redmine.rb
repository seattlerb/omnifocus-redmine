require 'yaml'

module OmniFocus::Redmine
  VERSION = '1.2.4'
  PREFIX  = "RM"

  def load_or_create_redmine_config
    path   = File.expand_path "~/.omnifocus-redmine.yml"
    config = YAML.load(File.read(path)) rescue nil

    unless config then
      config = {
        :user_id       => "20",
        :redmine_url   => "http://redmine",
        :username      => "UserName",
        :password      => "Password",
        :just_project  => false
      }

      File.open(path, "w") { |f|
        YAML.dump(config, f)
      }

      abort "Created default config in #{path}. Go fill it out."
    end

    config
  end

  def populate_redmine_tasks
    config       = load_or_create_redmine_config
    redmine_url  = config[:redmine_url]
    user_id      = config[:user_id]
    username     = config[:username]
    password     = config[:password]
    just_project = config[:just_project]

    # Authenticate if the user name and password are defined
    if username and password then
      mechanize.basic_auth(username, password)
    end

    default_query = "#{redmine_url}/issues.xml?assigned_to_id=#{user_id}"

    unless config[:queries]
      process_query_results(default_query, redmine_url, just_project)
    else
      queries = config[:queries]
      queries.each do |q|
        process_query_results("#{default_query}&#{q}",
                              redmine_url,
                              just_project)
      end
    end
  end

  def process_query_results(query, redmine_url, just_project)
    begin
      mechanize.get(query)
    rescue Mechanize::ResponseCodeError => e
      if e.response_code == "401" then
        abort "Unauthorized.  Check username and password in .omnifocus-redmine"
      end
    end

    details = Nokogiri.parse(mechanize.current_page.body)

    issues = details.root.xpath('//issue')

    issues.each do |i|
      bug_number = i.xpath('./id').text
      ticket_id = "#{PREFIX}##{bug_number}"

      if existing[ticket_id]
        project = existing[ticket_id]
        bug_db[project][ticket_id] = true
      else
        product = i.xpath('./project/@name').text.downcase
        title = i.xpath('./subject').text
        component = i.xpath('./category/@name').text
        if just_project then
          project = "#{product}"
        else
          project = "#{product}-#{component}"
        end
        url = "#{redmine_url}/issues/#{bug_number}"

        bug_db[project][ticket_id] = ["#{ticket_id}: #{title}", url]
      end
    end

  end
end
