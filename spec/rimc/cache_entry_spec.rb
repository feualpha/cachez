RSpec.describe Rimc::CacheEntry do
  describe '#expire?' do
    context 'nil expire time' do
      let(:entry) { build(:cache_entry, :forever) }
      it { expect(entry.expired?).to be false }
    end

    context 'not expired' do
      let(:expire_time) { Time.new(2018, 9, 26, 1, 1, 1) }
      let(:current_time) { Time.new(2018, 9, 26, 1, 1, 0) }
      let(:entry) { build(:cache_entry, expire_time: expire_time) }

      before do
        allow(Time).to receive(:now).and_return current_time
      end

      it { expect(entry.expired?).to be false }
    end

    context 'expired' do
      let(:expire_time) { Time.new(2018, 9, 26, 1, 1, 1) }
      let(:current_time) { Time.new(2018, 9, 26, 1, 1, 2) }
      let(:entry) { build(:cache_entry, expire_time: expire_time) }

      before do
        allow(Time).to receive(:now).and_return current_time
      end

      it { expect(entry.expired?).to be true }
    end
  end
end
