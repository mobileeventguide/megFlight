$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'minitest/autorun'
require 'meg_flight'

class MegFlightTest < MiniTest::Unit::TestCase
  def setup                                        
    @incorrect_options = {
      :ipa => "test.ipa",
      :identifier => 'gd.event.testApp2012',
      :title => "Test App 2012",
      :subtitle => "v0.81",
      :host_url => "http://example.com/gd.event.testApp2012"
    }                                              
    @options = {
      :ipa => "meg_flight/test/assets/test.ipa",
      :identifier => 'gd.event.testApp2012',
      :title => "Test App 2012",
      :subtitle => "v0.81",
      :host_url => "http://example.com/gd.event.testApp2012"
    }   
  end

  def test_create_package_works_if_image57_does_exist
    opts = @options.merge(:image57 => "http://placekitten.com/57/57")
    mf = MegFlight.new(opts)
    working_dir = mf.create_package
    assert_match(mf.image57, /placekitten/)
    assert working_dir, "working_dir: #{working_dir}"
  end 

  def test_create_package_works_if_image512_does_exist
    opts = @options.merge(:image512 => "http://placekitten.com/512/512")
    mf = MegFlight.new(opts)
    working_dir = mf.create_package
    assert_match(mf.image512, /placekitten/)
    assert working_dir, "working_dir: #{working_dir}"
  end  

  def test_create_package_works_if_image512_does_not_exist
    opts = @options.merge(:image512 => "foo")
    mf = MegFlight.new(opts)
    working_dir = mf.create_package
    assert_match(mf.image512, /512\/512\/technics/)
    assert working_dir, "working_dir: #{working_dir}"
  end

  def test_create_package_works_if_image57_does_not_exist
    opts = @options.merge(:image57 => "foo")
    mf = MegFlight.new(opts)
    working_dir = mf.create_package
    assert_match(mf.image57, /57\/57\/technics/)
    assert working_dir, "working_dir: #{working_dir}"
  end

  def test_create_package_works_if_ipa_does_not_exist
    working_dir = MegFlight.new(:ipa => "foo").create_package
    assert working_dir.nil?, "working_dir: #{working_dir}"
  end

  def test_create_package_works_if_options_are_correct
    m = MegFlight.new(@options)
    working_dir = m.create_package
    assert working_dir, "working_dir: #{working_dir}"
    glob = Dir.glob(working_dir + '**/*').join("\n")
    assert_match(glob, /index\.html$/)
    assert_match(glob, /manifest\.plist$/)
    assert_match(glob, /enterprise\.ipa$/)
    assert_match(glob, /57\.png$/)
    assert_match(glob, /512\.png$/)
  end
end
