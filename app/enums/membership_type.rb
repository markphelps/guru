class MembershipType < ClassyEnum::Base
  owner :member
end

class MembershipType::Weekly < MembershipType
end

class MembershipType::Monthly < MembershipType
end

class MembershipType::Annual < MembershipType
end

class MembershipType::Visit < MembershipType
end
