# Oxford Hub Phone Links

A platform for administering [Oxford Hub's Phone Links](https://www.oxfordhub.org/phone-links) programme.

Phone Links supports isolated people by linking them up with someone who can offer companionship and friendship through regular phone calls.

## Get in touch

If you're interesting in hearing more about the codebase or Phone Links programme, please get in touch with [Oxford Hub](https://www.oxfordhub.org/) or [Oxford Code Lab](https://www.oxfordcodelab.com/).

## Quickstart

This app is a standard [rails](https://rubyonrails.org/) app.

### Requirements

1. You will need to be running ruby 2.7.2.
1. You will also need to have [postgres](https://www.postgresql.org/download/) installed and running and package manager [yarn](https://classic.yarnpkg.com/en/).

### Installation

1. Install the project's dependencies by running
   ```
   bundle install
   ```
1. Create the database and some fake data by running
   ```
   rails db:create
   rails db:migrate
   rails db:seed
   ```
1. Install the js packages by running
   ```
   yarn
   ```
1. Run the rails server by running
   ```
   rails s
   ```
1. In a separate tab, run the js webpack server:
   ```
   bin/webpack-dev-server
   ```

### Tests

1. Install chromedriver. On a mac, chromedriver can be installed via homebrew
   ```
   brew install chromedriver
   ```

You may need to follow [these](https://stackoverflow.com/questions/60362018/macos-catalinav-10-15-3-error-chromedriver-cannot-be-opened-because-the-de/60362134#60362134) instructions to bypass security issues.

2. Then use the following command to run the tests:
   ```
   bundle exec rspec
   ```

### Contributing

Please get in touch with Oxford Code Lab (support@oxfordcodelab.com) if you'd like to contribute. Or create a pull request!

We're very grateful for all contributions!

## Funding

This project was funded as part of the Catalyst and The National Lottery Community Fund COVID-19 Digital Response fund.

## License

This code is released under a GNU Lesser General Public License (LGPL).
