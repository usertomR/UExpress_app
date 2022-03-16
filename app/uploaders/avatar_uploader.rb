class AvatarUploader < CarrierWave::Uploader::Base
  # 参考記事:https://qiita.com/Atakasu697/items/646e356f5800d10aa548#rmagic%E3%81%A7%E7%94%BB%E5%83%8F%E3%81%AE%E5%8A%A0%E5%B7%A5%E3%82%92%E8%A1%8C%E3%81%86

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add an allowlist of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_allowlist
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  # ここから、デフォルト(ここから上は全部コメントアウトされてた)では載っていない部分
  # URL: https://github.com/carrierwaveuploader/carrierwave#securing-uploads
  # URL: https://github.com/carrierwaveuploader/carrierwave#setting-the-content-type
  # このuploaderは、「image」content_typeのみ受け付けるという設定。脆弱性と関係あるらしい。
  # ただ、version0.11.0以降、実行時に必要な[mime-types]gemがcontent_typeの設定をするらしい。
  # 「ローカル環境の」yarn.lockに載っていたのでコメントアウトしておく。

  # def content_type_allowlist
  #  /image\//
  # end

  # URL :https://github.com/carrierwaveuploader/carrierwave/blob/master/lib/carrierwave/processing/mini_magick.rb#L75
  # 必要なら画像を切り抜く。デフォルトでは写真の中心の周りを切り取る。
  process resize_to_fill: [800, 800]

  version :thumb do
    process resize_to_fill: [75, 75]
  end

  version :thumb_mid do
    process resize_to_fill: [50, 50]
  end

  version :thumb_min do
    process resize_to_fill: [25, 25]
  end
end
