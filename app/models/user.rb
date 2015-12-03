class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  #protect_from_forgery with: :exception
  #before_filter :configure_permitted_parameters, if: :devise_controller?

  # paperclip
  #has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  #validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  has_attached_file :avatar,
                    :default_url => '/system/:attachment/missing.png',
                    :path => ":rails_root/public/system/:attachment/:id/:basename_:style.:extension",
                    :url => "/system/:attachment/:id/:basename_:style.:extension",
                    :styles => {
                        :thumb    => ['100x100#',  :jpg, :quality => 70],
                        :preview  => ['480x480#',  :jpg, :quality => 70],
                        :large    => ['600>',      :jpg, :quality => 70],
                        :retina   => ['1200>',     :jpg, :quality => 30]
                    },
                    :convert_options => {
                        :thumb    => '-set colorspace sRGB -strip',
                        :preview  => '-set colorspace sRGB -strip',
                        :large    => '-set colorspace sRGB -strip',
                        :retina   => '-set colorspace sRGB -strip -sharpen 0x0.5'
                    }
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  #validates_attachment_presence :avatar

  after_create :default_role

  private
  def default_role
    add_role(:user) if self.roles.blank?
  end

  #def configure_permitted_parameters
  #  devise_parameter_sanitizer.for(:user) << :avatar
  #end
end
