module OmniFocus::Redmine
  VERSION = '1.0.0'

  def load_or_create_redmine_config
    path   = File.expand_path "~/.omnifocus-redmine.yml"
    config = YAML.load(File.read(path)) rescue nil

    unless config then
      config = {
        :user          => "Admin User",
        :redmine_url   => "http://redmine",
      }

      File.open(path, "w") { |f|
        YAML.dump(config, f)
      }

      abort "Created default config in #{path}. Go fill it out."
    end

    config
  end

  def populate_redmine_tasks
    config      = load_or_create_redmine_config
    redmine_url = config[:redmine_url]
    user    = config[:user]

    query = "#{redmine_url}/issues.xml?assigned_to='#{user}'"

    mechanize.get(query)
    details = Nokogiri.parse(mechanize.current_page.body)

    issues = details.root.xpath('//issue')

    issues.each do |i|
      bug_number = i.xpath('./id').text
      ticket_id = "RM##{bug_number}"

      if existing[ticket_id]
        project = existing[ticket_id]
        bug_db[project][ticket_id] = true
      else
        product = i.xpath('./project/@name').text.downcase
        title = i.xpath('./subject').text
        component = i.xpath('./category/@name').text
        project = "#{product}-#{component}"
        url = "http://#{redmine_url}/issues/#{bug_number}"

        bug_db[project][ticket_id] = ["#{ticket_id}: #{title}", url]
      end
    end
  end
end
