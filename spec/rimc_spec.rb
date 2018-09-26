RSpec.describe Rimc do
  it 'has a version number' do
    expect(Rimc::VERSION).not_to be nil
  end

  def set_rimc_cache_entries(entries)
    Rimc.instance_variable_set :@cache_entries, entries
  end

  def build_single_hash(key, value)
    { key => value }
  end

  def set_current_time(current_time)
    allow(Time).to receive(:now).and_return current_time
  end

  describe '.set' do
    let(:cache_key) { double('cache key') }
    let(:cached_object) { double('cached_object') }
    let(:ttl) { 60 }
    let(:current_time) { Time.new(2018, 9, 26, 1, 1, 0) }

    before do
      set_current_time(current_time)
    end

    subject do
      Rimc.set(cache_key, cached_object, ttl)
      Rimc.send(:cache_entries)[cache_key]
    end

    it { expect(subject.cached_object).to eq cached_object }
    it { expect(subject.expire_time - current_time).to eq ttl }
  end

  describe '.get' do
    context 'expired' do
      let(:expire_time) { Time.new(2018, 9, 26, 1, 1, 1) }
      let(:current_time) { Time.new(2018, 9, 26, 1, 1, 2) }
      let(:cache_entry) { build(:cache_entry, expire_time: expire_time) }
      let(:cache_key) { double('cache key') }

      before do
        set_rimc_cache_entries build_single_hash(cache_key, cache_entry)
        set_current_time(current_time)
      end

      subject { Rimc.get(cache_key) }

      it { expect(subject).to be_nil }
    end

    context 'not expired' do
      let(:expire_time) { Time.new(2018, 9, 26, 1, 1, 1) }
      let(:current_time) { Time.new(2018, 9, 26, 1, 1, 0) }
      let(:cache_entry) { build(:cache_entry, expire_time: expire_time) }
      let(:cache_key) { double('cache key') }

      before do
        set_rimc_cache_entries build_single_hash(cache_key, cache_entry)
        set_current_time(current_time)
      end

      subject { Rimc.get(cache_key) }

      it { expect(subject).to eq cache_entry.cached_object }
    end
  end

  describe '.cache' do
    context 'expired' do
      let(:cache_key) { double('cache key') }
      let(:cache_entry) { build(:cache_entry) }
      let(:cached_object) { double('cache object') }
      let(:ttl) { 60 }

      before do
        allow(cache_entry).to receive(:expired?).and_return true
        set_rimc_cache_entries build_single_hash(cache_key, cache_entry)
      end

      it { expect(Rimc.cache(cache_key, ttl)).not_to eq cache_entry.cached_object }
      it { expect { |b| Rimc.cache(cache_key, ttl, &b) }.to yield_control }
    end

    context 'not expired' do
      let(:cache_key) { double('cache key') }
      let(:cache_entry) { build(:cache_entry) }
      let(:cached_object) { double('cache object') }
      let(:ttl) { 60 }

      before do
        allow(cache_entry).to receive(:expired?).and_return false
        set_rimc_cache_entries build_single_hash(cache_key, cache_entry)
      end

      it { expect(Rimc.cache(cache_key, ttl)).to eq cache_entry.cached_object }
      it { expect { |b| Rimc.cache(cache_key, ttl, &b) }.not_to yield_control }
    end
  end
end
