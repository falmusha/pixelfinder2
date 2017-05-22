namespace :pxfinder do

  namespace :crawl do
    desc 'Crawl photos from Flickr'
    task :flickr, [:num_of_photos] do |_, args|
      Pxfinder::Crawler.crawl(Pxfinder::Crawler::FlickrClient::NAME,
                              args[:num_of_photos].to_i)
    end

    desc 'Crawl photos from 500px'
    task :fhpx, [:num_of_photos] do |_, args|
      Pxfinder::Crawler.crawl(Pxfinder::Crawler::FHPxClient::NAME,
                              args[:num_of_photos].to_i)
    end
  end
end
