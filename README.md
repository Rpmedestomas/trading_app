# Stonks | Trading App

    Ruby Version ruby-2.7.4

## Installation

```
git clone https://github.com/Rpmedestomas/trading_app.git
```

```
cd trading_app
```

```
For Windows:

    sudo service postgresql start
```

```
For Mac:

    brew services start postgresql
```

```
bundle install
```

```
rails db:migrate
```

```
rails db:seed
```

```
For Windows:

    Open database.yml
    Uncomment username and password
```

```
For Mac:

    Open database.yml
    Comment username and password
```

```
rails s
```

## Demo

<br/>

## Sample Credentials

    Admin

        email: admin@example.com

        password: 123456

    User

        email: user@example.com

        password: 123456

## Features

-   User is able to create new account
-   User can edit account information
-   User can view the top 10 most active stocks
-   User can search for a specific stock
-   User can buy/sell stock
