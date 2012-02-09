zendesk-populator
=================

Description
-----------

Zendesk Populator has two components:

* A front-end for adding users to a DB and exporting to CSV
* A simple command line tool to populate Zendesk organizations and users
from a CSV file.

They'll shortly also be integrated but currently run seperately.


## Front-End ##

### Installation & Usage ###

1. Run bundler.

        $ bundle install

2. Create config.yml and database.yml from the example files

3. Run database migration.

        $ rake db:migrate

4. Rackup the application.

5. You can now enter new users. You must supply the company name, full
   name and email address.

6. Browse to http://application/backstage to see the currently included
   users and download them as a CSV file. This section is password 
   protected using the username and password defined in the config.yml
   file.

## Command line tool ##

### Installation & Usage ###

1. Run bundler

2.  Update the `zendesk_site`, `zendesk_user` and `zendesk_password` 
    variables in the `zdpop_config.yaml` file. The default location for the
    file is `/etc/zdpop_config.yaml`. You can override this with the 
    `-c` or `--config-file` command line option. An example file is 
    included.

3.  The zdpop_data.csv file contains the data to be loaded in the form:
    
        org_name,user_name,email_address
    
    The default file location is `/tmp/zdpop_data.csv` but you can
    override this via the `-d` or `--data-file` command line option.

    You can download this file from the front-end.

4.  Run the command to create the required organizations and users:

        $ zdpop

Author
------

James Turnbull <james@lovedthanlost.net>

License
-------

    Author:: James Turnbull (<james@lovedthanlost.net>)
    Copyright:: Copyright (c) 2011 James Turnbull
    License:: Apache License, Version 2.0

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
