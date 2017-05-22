require 'net/http'
require 'json'

namespace :pxfinder do

  namespace :dxomark do
    desc 'Generate lens info for each manufacturer'
    task :lenses, [:path] do |_, args|
      lenses = fetch(:lenses)
      write_to_file(lenses, args[:path], 'lenses.json')
    end

    desc 'Generate camera info for each manufacturer'
    task :cameras, [:path] do |_, args|
      cameras = fetch(:cameras)
      write_to_file(cameras, args[:path], 'cameras.json')
    end
  end
end

PARAMS = {
  lenses: {
    url: 'https://www.dxomark.com/daklens/ajax/jsonpreview',
    properties: [
      'name'
    ]
  },
  cameras: {
    url: 'https://www.dxomark.com/daksensor/ajax/jsontested',
    properties: [
      'name'
    ]
  }
}


def fetch(what)
  uri = URI(PARAMS[what][:url])
  lenses = JSON.parse(Net::HTTP.get(uri))['data']
  lenses_by_make = lenses.group_by {|e| e['brand']}

  format(lenses_by_make, what)
end

def format(list_by_make, model_type)
  formatted = {}
  list_by_make.each_pair do |make, models|
    models.each do |model|
      new_model = model.select do |property, _|
        PARAMS[model_type][:properties].include?(property)
      end

      if formatted.has_key?(make)
        formatted[make].push(new_model)
      else
        formatted[make] = [new_model]
      end
    end
  end
  formatted
end

def write_to_file(hash, path, filename)
  dir = File.directory?(path) ? path : Dir.pwd

  File.open(File.join(dir, filename), 'w') do |f|
    f.write(JSON.pretty_generate(hash))
  end
end
