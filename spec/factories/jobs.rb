FactoryGirl.define do
  factory :job do
    title 'Front-end Engineer'
    description 'Sto carpo vis suspendo. Alius amissio adfectus ven...'
    phone '254-654-1489'
    email 'kayla@feeney.biz'
    salary 25000
    all_tags 'Computers, Tools, Books'

    factory :rails_job do
      title 'Rails Engineer'
    end

    factory :test_job do
      title 'Test'
      all_tags 'Test1, Test2'
    end

    factory :invalid_job do
      title 'Invalid'
      phone nil
    end
  end

end
