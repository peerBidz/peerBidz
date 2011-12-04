class Order < ActiveRecord::Base
  belongs_to :cart
  attr_accessor :card_number, :card_verification

  validate_on_create :validate_card

  def purchase
#    response = GATEWAY.purchase(price_in_cents, credit_card, purchase_options)
#    transactions.create!(:action => "purchase", :amount => price_in_cents, :response => response)
#    cart.update_attribute(:purchased_at, Time.now) if response.success?
#    response.success?
  end

  def price_in_cents
#    (cart.total_price*100).round
  end

  private

  def purchase_options
    {
#      :billing_address => {
#        :name     => "",
#        :address1 => "",
#        :city     => "",
#        :state    => "",
#        :country  => "",
#        :zip      => ""
#      }
    }
  end

  def validate_card
    unless credit_card.valid?
      credit_card.errors.full_messages.each do |message|
        errors.add_to_base message
      end
    end
  end

  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      :type               => card_type,
      :number             => card_number,
      :verification_value => card_verification,
      :month              => card_expires_on.month,
      :year               => card_expires_on.year,
      :first_name         => first_name,
      :last_name          => last_name
    )
  end
end
