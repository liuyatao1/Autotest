require 'sqlite3'
require 'active_record'
require 'byebug'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'customers.sqlite3')

class Customer < ActiveRecord::Base
  def to_s
    "  [#{id}] #{first} #{last}, <#{email}>, #{birthdate.strftime('%Y-%m-%d')}"
  end

  #  NOTE: Every one of these can be solved entirely by ActiveRecord calls.
  #  You should NOT need to call Ruby library functions for sorting, filtering, etc.

  def self.any_candice
    # YOUR CODE HERE to return all customer(s) whose first name is Candice
    # probably something like:  Customer.where(....)
    Customer.where(first: 'Candice')

  end

  def self.with_valid_email
    # YOUR CODE HERE to return only customers with valid email addresses (containing '@')
    Customer.where('email LIKE ?', '%@%')
  end

  def self.with_dot_org_email
    Customer.where('email LIKE ?', '%@%.org')
  end

  def self.with_invalid_email
    Customer.where('email LIKE ?', '%').where.not('email LIKE ?', '%@%')
  end

  def self.with_blank_email
    Customer.where(email: nil)
  end

  def self.born_before_1980
    Customer.where('birthdate < ?', '1980-01-01')
    # select * from customers where birthdate < '1980-01-01'
  end

  def self.with_valid_email_and_born_before_1980
    Customer.where('birthdate < ? AND email LIKE ?', '1980-01-01', '%@%')
  end

  def self.last_names_starting_with_b
    Customer.where('last LIKE ?', 'B%').order(birthdate: :asc)
    # select * from customers where(last REGEXP '^B.*') order by birthdate;
  end

  def self.twenty_youngest
    Customer.order(birthdate: :desc).first(20)
  end

  def self.update_gussie_murray_birthdate
    c = Customer.find_by(first: 'Gussie')
    c.birthdate = '2004-02-08'
    c.save
  end

  def self.change_all_invalid_emails_to_blank
    cstm = Customer.where("email != '' AND email IS NOT NULL and email NOT LIKE '%@%'")
    cstm.each do |c|
      c.email = ''
      c.save
    end
  end

  def self.delete_meggie_herman
    c = Customer.find_by(:first => 'Meggie', :last => 'Herman')
    c.delete
  end

  def self.delete_everyone_born_before_1978
    cstm = Customer.where('birthdate < ?' ,'1978-01-01')
    cstm.delete_all
  end
  # etc. - see README.md for more details
end
