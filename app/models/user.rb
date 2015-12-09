class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

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
  validates_attachment_content_type :avatar, :content_type => %r{/\Aimage\/.*\Z/}

  after_create :default_role

  private

  def default_role
    add_role(:user) if roles.blank?
  end
end
