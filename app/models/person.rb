class Person < ActiveRecord::Base
  include ApplicationHelper

  mount_uploader :localphoto, PeoplephotoUploader
  store_accessor :miscattributes, :key1, :key2
  belongs_to :person_category
  has_many :document_person_maps
  has_many :documents, :through => :document_person_maps
  has_many :product_person_maps
  has_many :products, :through => :product_person_maps
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :grants
  has_and_belongs_to_many :research_areas

  validates :lastname, presence: {message: ": Person's last name is missing"}
  validates :firstname, presence: {message: ": Person's first name is missing"}
  validates :bs_year, :ms_year, :phd_year, allow_nil: true, numericality: {only_integer: true,
            greater_than: 1970, less_than: 2070,
            message: ": Person's degree year does not seem right"}
  validates :url, :urlphoto, :urldepartment, :urlorganization,
            allow_nil: true, allow_blank: true, format: {with: URI::regexp(%w(http https)),  message: ": URL is malformed"}
  validates :email, allow_nil: true, format: {with: Labweb::RE_EMAIL, message: ": Person's email is in wrong format"}
  validates :phonework, allow_nil: true, format: {with: Labweb::RE_PHONE, message: ": Person's phone (Work) is in wrong format"}
  validates :phonehome, allow_nil: true, format: {with: Labweb::RE_PHONE, message: ": Person's phone (Home) is in wrong format"}
  validates :phonecell, allow_nil: true, format: {with: Labweb::RE_PHONE, message: ": Person's phone (Mobile) is in wrong format"}
  validates :fax, allow_nil: true, format: {with: Labweb::RE_PHONE, message: ": Person's fax is in wrong format"}
  
  validates_inclusion_of :useurlphoto, :in => [true, false], message: ": Missing photo source: by url or by uploading"
  
  def get_photo_url
    if useurlphoto && urlphoto.present?
      urlphoto
    elsif !useurlphoto && localphoto.present?
      localphoto
    elsif urlphoto.present?
      urlphoto
    elsif localphoto.present?
      localphoto
    else
      ENV["DEFAULT_MUGSHOT"]
    end
  end

  def get_name_first_middleinitial_last
    firstname\
        + (middleinitial.present? ? (' ' + middleinitial + '.') : '')\
        + ' ' + lastname
  end
end
