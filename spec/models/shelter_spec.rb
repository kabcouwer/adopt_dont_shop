require 'rails_helper'

RSpec.describe Shelter, type: :model do
  describe 'relationships' do
    it { should have_many(:pets) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:rank) }
    it { should validate_numericality_of(:rank) }
  end

  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    @pet_4 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)

    @app_1 = Application.create(name: 'Alice Pieszecki', street: '407 Race St', city: 'Denver', state: 'CO', zip_code: 80305, description: 'A reason', status: 'pending')
    @app_2 = Application.create(name: 'Bette Porter', street: '777 Corona St', city: 'Denver', state: 'CO', zip_code: 80221, description: 'B reason', status: 'pending')
    @app_3 = Application.create(name: 'Shane McCutchen', street: '1234 Pine Ave', city: 'Arvada', state: 'CO', zip_code: 80218, description: 'C reason', status: 'pending')
    @app_4 = Application.create(name: 'Jenny Schecter', street: '2043 21st St', city: 'Denver', state: 'CO', zip_code: 80218, description: 'D reason', status: 'rejected')
    @app_5 = Application.create(name: 'Tina Kennard', street: '12 Colorado Blvd', city: 'Denver', state: 'CO', zip_code: 80210, description: 'E reason', status: 'in progress')

    PetApplication.create!(application: @app_1, pet: @pet_1)
    PetApplication.create!(application: @app_2, pet: @pet_2)
    PetApplication.create!(application: @app_3, pet: @pet_3)
    PetApplication.create!(application: @app_4, pet: @pet_4)
  end

  describe 'class methods' do
    describe '#search' do
      it 'returns partial matches' do
        expect(Shelter.search("Fancy")).to eq([@shelter_3])
      end
    end

    describe '#order_by_recently_created' do
      it 'returns shelters with the most recently created first' do
        expect(Shelter.order_by_recently_created).to eq([@shelter_3, @shelter_2, @shelter_1])
      end
    end

    describe '#order_by_number_of_pets' do
      it 'orders the shelters by number of pets they have, descending' do
        expect(Shelter.order_by_number_of_pets).to eq([@shelter_1, @shelter_3, @shelter_2])
      end
    end

    describe '#order_by_reverse_alphabetical' do
      it 'orders the shelters by reverse alphabetical order' do
        expect(Shelter.order_by_reverse_alphabetical).to eq([@shelter_2, @shelter_3, @shelter_1])
      end
    end

    describe '#shelters_with_pending_applications' do
      xit 'displays shelters with pending applications' do
        expect(Shelter.shelters_with_pending_applications).to eq([@shelter_1, @shelter_3])
      end
    end
  end

  describe 'instance methods' do
    describe '.adoptable_pets' do
      it 'only returns pets that are adoptable' do
        expect(@shelter_1.adoptable_pets).to eq([@pet_2, @pet_4])
      end
    end

    describe '.alphabetical_pets' do
      it 'returns pets associated with the given shelter in alphabetical name order' do
        expect(@shelter_1.alphabetical_pets).to eq([@pet_4, @pet_2])
      end
    end

    describe '.shelter_pets_filtered_by_age' do
      it 'filters the shelter pets based on given params' do
        expect(@shelter_1.shelter_pets_filtered_by_age(5)).to eq([@pet_4])
      end
    end

    describe '.pet_count' do
      it 'returns the number of pets at the given shelter' do
        expect(@shelter_1.pet_count).to eq(3)
      end
    end
  end
end
