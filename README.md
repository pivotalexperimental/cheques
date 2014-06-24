### What

Have you been writing your cheques? That's old.. 

You know what you should do? You should **PRINT YOUR CHEQUES**!

*Proudly brought to you by Team Singapore.*

### Requirements

Requires Ruby 1.9.2

### Installation

    $ git clone https://github.com/pivotalexperimental/cheques.git
    $ cd cheques
    $ gem install bundle --no-ri --no-rdoc
    $ bundle install
    $ cp config/database.yml.example config/database.yml
    $ cp config/authentication.yml.example config/authentication.yml
    $ bundle exec rake db:setup

### How

- CSV should be have the following headers: ``[Date, Chq No, Name, Description, Amount]``
