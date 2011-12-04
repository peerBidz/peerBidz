require "active_merchant"

# Send requests to the gateway's test servers
ActiveMerchant::Billing::Base.mode = :test

# Create a new credit card object
credit_card = ActiveMerchant::Billing::CreditCard.new(
  :type               => "visa",
  :number             => "4024007148673576",
  :verification_value => "123",
  :month              => 1,
  :year               => Time.now.year+1,
  :first_name         => "Rocking",
  :last_name          => "Rails"
)

if credit_card.valid?
  puts "Credit card is valid"
else
  puts "Error: credit card is not valid. #{credit_card.errors.full_messages.join('. ')}"
end