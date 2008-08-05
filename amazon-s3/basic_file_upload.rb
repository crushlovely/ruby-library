#!/usr/bin/env ruby
require 'rubygems'
require 'aws/s3'

AWS::S3::Base.establish_connection!(
  :access_key_id => ENV['AMAZON_ACCESS_KEY_ID'],
  :secret_access_key => ENV['AMAZON_SECRET_ACCESS_KEY']
)

# file = ARGV.first
bucket = "nygasp"

files = ['press/images/general/nygasp_montage_1.jpg', 'press/images/general/nygasp_montage_2.jpg', 'press/images/general/party_with_nygasp.jpg', 'press/images/general/the_players_pursue_the_maestro.jpg', 'press/images/hms_pinafore/CapNJoe_Pinafore.jpg', 'press/images/hms_pinafore/KeithJurosko.jpg', 'press/images/hms_pinafore/Pinafore_Production.jpg', 'press/images/hms_pinafore/RossDavidCrutchlow_TylerBunch.jpg', 'press/images/hms_pinafore/RossKeithTyler_Pinafore.jpg', 'press/images/hms_pinafore/StephenOBrien_HeideHolcolmb_KeithJurosko.jpg', 'press/images/hms_pinafore/StephenOBrien.jpg', 'press/press_releases/HMSPinafore-SamplePressRelease.pdf', 'press/images/the_mikado/Chase_Mahon_Quint_Bryant).jpg', 'press/images/the_mikado/KathleenLarsonKatisha.jpg', 'press/images/the_mikado/KeithFace.jpg', 'press/images/the_mikado/KoKo_Quint.jpg', 'press/images/the_mikado/Laurelyn_Mikado.jpg', 'press/images/the_mikado/Mikado2.jpg', 'press/images/the_mikado/past_seasons.jpg', 'press/images/the_mikado/QuintParks_Mikado.jpg', 'press/images/the_mikado/repertoire.jpg', 'press/images/the_mikado/TheMikado.jpg', 'press/images/the_mikado/ThreeMaids_Mikado.jpg', 'press/images/the_mikado/ThreeMaids2_Mikado.jpg', 'press/images/the_pirates_of_penzance/KeithPirateKing.jpg', 'press/images/the_pirates_of_penzance/Laurelyn_Mabel.jpg', 'press/images/the_pirates_of_penzance/MajorGeneral_Steve Quint.jpg', 'press/images/the_pirates_of_penzance/OnTour.jpg', 'press/images/the_pirates_of_penzance/pirates1.jpg', 'press/images/the_pirates_of_penzance/PiratesChorusLine.jpg', 'press/images/the_pirates_of_penzance/PiratesQuintet.jpg', 'press/press_releases/TheMikado-SamplePressRelease.pdf', 'press/press_releases/ThePiratesofPenzance-SamplePressRelease.pdf']

files.each do |file|
  AWS::S3::S3Object.store(File.basename(file), 
                          open(file), 
                          bucket, 
                          :access => :public_read)
end

files.each do |file|
  puts AWS::S3::S3Object.url_for(File.basename(file), bucket)[/[^?]+/]
end