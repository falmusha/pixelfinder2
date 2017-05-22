require 'roda'
require 'pxfinder/web/photo_search'

module Pxfinder
  module Web
    class App < Roda
      plugin :render, views: 'lib/pxfinder/web/views', escape: :erubi
      plugin :public, root: 'static'
      plugin :json, classes: [Array, Hash, Sequel::Model]

      route do |r|
        r.public

        r.root { view 'search' }
        # r.get('search') { view 'search' }

        # JSON API
        r.on 'api' do
          r.get 'photos' do
            search = Pxfinder::Web::PhotoSearch.new(r.params)
            $log.info("App: params #{search.filters}, page: #{search.page}")

            search.json_results
          end

          r.get('cameras') { Pxfinder::Models::Camera.select(:id, :name).all }
          r.get('lenses') { Pxfinder::Models::Lens.select(:id, :name).all }
        end
      end
    end
  end
end
