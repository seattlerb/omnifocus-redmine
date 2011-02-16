= omnifocus_redmine

* http://rubyforg.org/projects/seattlerb

== DESCRIPTION:

Plugin for the omnifocus gem to provide synchronization with Redmine Issues.

This plugin uses the Redmine REST API. It must be enabled by an administrator
for the plugin to work.  

The first time this runs it creates a yaml file in your home directory for 
the configuration data.

 * redmine_url is required. This is the base url for the redmine repository.

 * user_id is required. To find your user id login and go to the my account
   page. Your user_id is the number at the end of the url for my account.

 * username is optional. It is used if the redmine server requires 
   authentication.  

 * password is optional. It is used if the redmine server requires 
   authentication.  

 * queries is optional. It is used for custom queries or multiple queries. 
   The queries config is an array of strings.  The strings will be appended 
   to a query of the form: 
      "http://redmine_url/issues.xml?assigned_to_id=user_id".

Example:
:user_id: 20
:redmine_url: http://redmine/
:username: me
:password: 1234
:queries: ["status_id=1", "status_id=2"]

== FEATURES/PROBLEMS:

* Provides redmine synchronization

== REQUIREMENTS:

* omnifocus

== INSTALL:

* sudo gem install omnifocus-redmine

== LICENSE:

(The MIT License)

Copyright (c) 2010 Aja Hammerly

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
