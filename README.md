zendesk-populator
=================

Description
-----------


Requirements
------------

* `httparty`
* `json`
* `csv`

Installation & Usage
-------------------

1.  Install the `httparty` and `json` gems on your Puppet master

        $ sudo gem install httparty json

2.  Install the zendesk-populator via the gem

3.  Update the `zendesk_site`, `zendesk_user` and `zendesk_password` 
    variables in the `zdpop_config.yaml` file. The default location for the
    file is `/etc/zdpop_config.yaml`. You can override this with the 
    `-c` or `--config-file` command line option. An example file is 
    included.

4.  The zdpop_data.csv file contains the data to be loaded in the form:
    
        org_name,user_name,email_address
    
    The default file location is `/tmp/zdpop_data.csv` but you can
    override this via the `-d` or `--data-file` command line option.

5.  Run the command to create the required organizations and users:

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
