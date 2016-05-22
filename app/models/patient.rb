class Patient < ActiveRecord::Base
	## Slug
  extend FriendlyId
  friendly_id :full_name, use: :slugged

	include Contactable
  include Addressable
	include Referrerable

	acts_as_paranoid
  acts_as_contactable
  alias :name :full_name
  
  acts_as_addressable
  acts_as_referrerable

  ## Relationship
  attr_accessor :ssn
  
	belongs_to :clinic

	has_many :referred_patients, class_name: 'Patient', as: :referrer

	belongs_to :employer_contact, class_name: 'Contact'
	accepts_nested_attributes_for :employer_contact

	belongs_to :employer_address, class_name: 'Address'
	accepts_nested_attributes_for :employer_address

	has_many :family_members, class_name: 'Patient', foreign_key: 'parent_patient_id'
	## Validations
	validate :contact_last_name_blank, :contact_sex_blank
	validates :overdue_fee_percentage, numericality: { greater_than: 0}, allow_blank: true
	validates :ssn, format: { with: /(\d{3}[-]?\d{2}[-]?\d{4}$)/, message: "should be in the following format: XXX-XX-XXXX" }, allow_blank: true

	## Callbacks
	before_save :assign_employer_addressable

	## Scopes
	scope :active, -> { where( is_active: true ) }
	scope :inactive, -> { where( is_active: false ) }
	scope :alphabetically, -> { includes(:contact).order('contacts.last_name ASC, contacts.first_name ASC')}

	## Callback Methods
	def assign_employer_addressable
		employer_address.addressable = employer_contact
	end

	## Instance Methods
	def title
		contact.name
	end

  def address_stamp
    address_stamp = []
    
    address_stamp << name
    address_stamp << address.line1
    address_stamp << address.line2
    address_stamp << contact.phone1
    
    address_stamp.compact.reject(&:blank?).join("\n")
  end

	def self.distinct_categories
	  Patient.active.map(&:category).uniq
	end

  def ssn
    encrypted_ssn
  end

  def active_text
    is_active ? 'active' : 'inactive'
  end

  def active_inverse_text
    !self.is_active ? 'active' : 'inactive'
  end
  
  def copy_details_from_patient(parent)
    if parent.present?
    	self.build_contact(contactable_type: 'Patient') unless self.contact.present?
    	self.build_address unless self.address.present?
    	self.build_employer_contact unless self.employer_contact.present?
    	self.build_employer_address unless self.employer_address.present?

      self.contact.last_name  		= parent.try(:contact).try(:last_name)
      self.contact.first_name 		= 'A Related'
      self.contact.sex 						= 'male'      
      self.contact.middle_initial = parent.try(:contact).try(:middle_initial)
      self.contact.phone1     = parent.try(:contact).try(:phone1)
      self.contact.phone2     = parent.try(:contact).try(:phone2)
      self.contact.phone3     = parent.try(:contact).try(:phone3)

      self.address.street   	= parent.try(:address).try(:street)
      self.address.street2  	= parent.try(:address).try(:street2)
      self.address.city     	= parent.try(:address).try(:city)
      self.address.state    	= parent.try(:address).try(:state)
      self.address.zipcode   	= parent.try(:address).try(:zipcode)

      self.clinic_id 					= parent.clinic_id      
      self.parent_patient_id 	= parent.parent_patient_id.blank? ? parent.id : parent.parent_patient_id
    end
    return self
  end

end
