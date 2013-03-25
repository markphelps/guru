class PaymentMethod < ClassyEnum::Base
  owner :payment
end

class PaymentMethod::Credit < PaymentMethod
end

class PaymentMethod::Check < PaymentMethod
end

class PaymentMethod::Cash < PaymentMethod
end
