### What

Have you been writing your cheques? That's old.. 

You know what you should do? You should **PRINT YOUR CHEQUES**!

*Proudly brought to you by Team Singapore.*

### Installation

    $ git clone git@github.com:pivotalprivate/cheques.git
    $ cd cheques
    $ gem install bundle --no-ri --no-rdoc
    $ bundle install

### How

- CSV should be have the following headers: ``[Date, Chq No, Name, Description, Amount]``

- Name the CSV file ``cheques.csv``

- Drop the CSV into the directory ``/csv``

- In console, run

  <code>$ ruby run.rb</code>

- PDF cheques will be generated in directory ``/cheques``
- Open the cheques and print them!
