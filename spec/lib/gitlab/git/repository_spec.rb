  let(:repository) { Gitlab::Git::Repository.new('default', TEST_REPO_PATH) }
  describe '#root_ref' do
    context 'with gitaly disabled' do
      before { allow(Gitlab::GitalyClient).to receive(:feature_enabled?).and_return(false) }

      it 'calls #discover_default_branch' do
        expect(repository).to receive(:discover_default_branch)
        repository.root_ref
      end
    end

    context 'with gitaly enabled' do
      before { stub_gitaly }

      it 'gets the branch name from GitalyClient' do
        expect_any_instance_of(Gitlab::GitalyClient::Ref).to receive(:default_branch_name)
        repository.root_ref
      end

      it 'wraps GRPC not found' do
        expect_any_instance_of(Gitlab::GitalyClient::Ref).to receive(:default_branch_name).
          and_raise(GRPC::NotFound)
        expect { repository.root_ref }.to raise_error(Gitlab::Git::Repository::NoRepository)
      end

      it 'wraps GRPC exceptions' do
        expect_any_instance_of(Gitlab::GitalyClient::Ref).to receive(:default_branch_name).
          and_raise(GRPC::Unknown)
        expect { repository.root_ref }.to raise_error(Gitlab::Git::CommandError)
      end
    end
  end

  describe "#rugged" do
    context 'with no Git env stored' do
      before do
        expect(Gitlab::Git::Env).to receive(:all).and_return({})
      end

      it "whitelist some variables and pass them via the alternates keyword argument" do
        expect(Rugged::Repository).to receive(:new).with(repository.path, alternates: [])

        repository.rugged
      end
    end

    context 'with some Git env stored' do
      before do
        expect(Gitlab::Git::Env).to receive(:all).and_return({
          'GIT_OBJECT_DIRECTORY' => 'foo',
          'GIT_ALTERNATE_OBJECT_DIRECTORIES' => 'bar',
          'GIT_OTHER' => 'another_env'
        })
      end

      it "whitelist some variables and pass them via the alternates keyword argument" do
        expect(Rugged::Repository).to receive(:new).with(repository.path, alternates: %w[foo bar])

        repository.rugged
      end
    end
  end

  describe '#branch_names' do

    context 'with gitaly enabled' do
      before { stub_gitaly }

      it 'gets the branch names from GitalyClient' do
        expect_any_instance_of(Gitlab::GitalyClient::Ref).to receive(:branch_names)
        subject
      end

      it 'wraps GRPC not found' do
        expect_any_instance_of(Gitlab::GitalyClient::Ref).to receive(:branch_names).
          and_raise(GRPC::NotFound)
        expect { subject }.to raise_error(Gitlab::Git::Repository::NoRepository)
      end

      it 'wraps GRPC other exceptions' do
        expect_any_instance_of(Gitlab::GitalyClient::Ref).to receive(:branch_names).
          and_raise(GRPC::Unknown)
        expect { subject }.to raise_error(Gitlab::Git::CommandError)
      end
    end
  describe '#tag_names' do

    context 'with gitaly enabled' do
      before { stub_gitaly }

      it 'gets the tag names from GitalyClient' do
        expect_any_instance_of(Gitlab::GitalyClient::Ref).to receive(:tag_names)
        subject
      end

      it 'wraps GRPC not found' do
        expect_any_instance_of(Gitlab::GitalyClient::Ref).to receive(:tag_names).
          and_raise(GRPC::NotFound)
        expect { subject }.to raise_error(Gitlab::Git::Repository::NoRepository)
      end

      it 'wraps GRPC exceptions' do
        expect_any_instance_of(Gitlab::GitalyClient::Ref).to receive(:tag_names).
          and_raise(GRPC::Unknown)
        expect { subject }.to raise_error(Gitlab::Git::CommandError)
      end
    end
  describe '#archive_prefix' do
    let(:project_name) { 'project-name'}

    before do
      expect(repository).to receive(:name).once.and_return(project_name)
    end

    it 'returns parameterised string for a ref containing slashes' do
      prefix = repository.archive_prefix('test/branch', 'SHA')

      expect(prefix).to eq("#{project_name}-test-branch-SHA")
    end

    it 'returns correct string for a ref containing dots' do
      prefix = repository.archive_prefix('test.branch', 'SHA')

      expect(prefix).to eq("#{project_name}-test.branch-SHA")
    end
  end

  describe '#archive' do
  describe '#archive_zip' do
  describe '#archive_bz2' do
  describe '#archive_fallback' do
  describe '#size' do
  describe '#has_commits?' do
  describe '#empty?' do
  describe '#bare?' do
  describe '#heads' do
  describe '#ref_names' do
  describe '#search_files' do
  context '#submodules' do
    let(:repository) { Gitlab::Git::Repository.new('default', TEST_REPO_PATH) }
  describe '#commit_count' do
    change_path = File.join(SEED_STORAGE_PATH, TEST_NORMAL_REPO_PATH, "CHANGELOG")
    untracked_path = File.join(SEED_STORAGE_PATH, TEST_NORMAL_REPO_PATH, "UNTRACKED")
    tracked_path = File.join(SEED_STORAGE_PATH, TEST_NORMAL_REPO_PATH, "files", "ruby", "popen.rb")
        @normal_repo = Gitlab::Git::Repository.new('default', TEST_NORMAL_REPO_PATH)
        @normal_repo = Gitlab::Git::Repository.new('default', TEST_NORMAL_REPO_PATH)
          normal_repo = Gitlab::Git::Repository.new('default', TEST_NORMAL_REPO_PATH)
          @normal_repo = Gitlab::Git::Repository.new('default', TEST_NORMAL_REPO_PATH)
          File.open(File.join(SEED_STORAGE_PATH, TEST_NORMAL_REPO_PATH, ".gitignore"), "r") do |f|
          FileUtils.rm_rf(SEED_STORAGE_PATH, TEST_NORMAL_REPO_PATH)
      @repo = Gitlab::Git::Repository.new('default', TEST_MUTABLE_REPO_PATH)
      @repo = Gitlab::Git::Repository.new('default', TEST_MUTABLE_REPO_PATH)
      @repo = Gitlab::Git::Repository.new('default', TEST_MUTABLE_REPO_PATH)
      @repo = Gitlab::Git::Repository.new('default', TEST_MUTABLE_REPO_PATH)
      @repo.remote_add("new_remote", SeedHelper::GITLAB_GIT_TEST_REPO_URL)
      @repo = Gitlab::Git::Repository.new('default', TEST_MUTABLE_REPO_PATH)
    before(:context) do
      repo = Gitlab::Git::Repository.new('default', TEST_REPO_PATH).rugged
    after(:context) do
      # Erase our commits so other tests get the original repo
      repo = Gitlab::Git::Repository.new('default', TEST_REPO_PATH).rugged
      repo.references.update("refs/heads/master", SeedRepo::LastCommit::ID)
    end

      let(:options) { { ref: "master", follow: true } }
        it "does not follow renames" do
          log_commits = repository.log(options.merge(path: "encoding"))
          aggregate_failures do
            expect(log_commits).to include(commit_with_new_name)
            expect(log_commits).to include(rename_commit)
            expect(log_commits).not_to include(commit_with_old_name)
          end
        context 'without offset' do
          it "follows renames" do
            log_commits = repository.log(options.merge(path: "encoding/CHANGELOG"))

            aggregate_failures do
              expect(log_commits).to include(commit_with_new_name)
              expect(log_commits).to include(rename_commit)
              expect(log_commits).to include(commit_with_old_name)
            end
          end
        context 'with offset=1' do
          it "follows renames and skip the latest commit" do
            log_commits = repository.log(options.merge(path: "encoding/CHANGELOG", offset: 1))

            aggregate_failures do
              expect(log_commits).not_to include(commit_with_new_name)
              expect(log_commits).to include(rename_commit)
              expect(log_commits).to include(commit_with_old_name)
            end
          end
        end

        context 'with offset=1', 'and limit=1' do
          it "follows renames, skip the latest commit and return only one commit" do
            log_commits = repository.log(options.merge(path: "encoding/CHANGELOG", offset: 1, limit: 1))

            expect(log_commits).to contain_exactly(rename_commit)
          end
        end

        context 'with offset=1', 'and limit=2' do
          it "follows renames, skip the latest commit and return only two commits" do
            log_commits = repository.log(options.merge(path: "encoding/CHANGELOG", offset: 1, limit: 2))

            aggregate_failures do
              expect(log_commits).to contain_exactly(rename_commit, commit_with_old_name)
            end
          end
        end

        context 'with offset=2' do
          it "follows renames and skip the latest commit" do
            log_commits = repository.log(options.merge(path: "encoding/CHANGELOG", offset: 2))

            aggregate_failures do
              expect(log_commits).not_to include(commit_with_new_name)
              expect(log_commits).not_to include(rename_commit)
              expect(log_commits).to include(commit_with_old_name)
            end
          end
        end

        context 'with offset=2', 'and limit=1' do
          it "follows renames, skip the two latest commit and return only one commit" do
            log_commits = repository.log(options.merge(path: "encoding/CHANGELOG", offset: 2, limit: 1))

            expect(log_commits).to contain_exactly(commit_with_old_name)
          end
        end

        context 'with offset=2', 'and limit=2' do
          it "follows renames, skip the two latest commit and return only one commit" do
            log_commits = repository.log(options.merge(path: "encoding/CHANGELOG", offset: 2, limit: 2))

            aggregate_failures do
              expect(log_commits).not_to include(commit_with_new_name)
              expect(log_commits).not_to include(rename_commit)
              expect(log_commits).to include(commit_with_old_name)
            end
          end
        it "does not follow renames" do
          log_commits = repository.log(options.merge(path: "CHANGELOG"))
          aggregate_failures do
            expect(log_commits).not_to include(commit_with_new_name)
            expect(log_commits).to include(rename_commit)
            expect(log_commits).to include(commit_with_old_name)
          end
        it "returns an empty array" do
          log_commits = repository.log(options.merge(ref: 'unknown'))
        expect(commits).to satisfy do |commits|
          commits.all? { |commit| commit.time >= options[:after] }
        expect(commits).to satisfy do |commits|
          commits.all? { |commit| commit.time <= options[:before] }
    context 'when multiple paths are provided' do
      let(:options) { { ref: 'master', path: ['PROCESS.md', 'README.md'] } }

      def commit_files(commit)
        commit.diff(commit.parent_ids.first).deltas.flat_map do |delta|
          [delta.old_file[:path], delta.new_file[:path]].uniq.compact
        end
      end

      it 'only returns commits matching at least one path' do
        commits = repository.log(options)

        expect(commits.size).to be > 0
        expect(commits).to satisfy do |commits|
          commits.none? { |commit| (commit_files(commit) & options[:path]).empty? }
        end
      end
  describe '#count_commits' do
    context 'with after timestamp' do
      it 'returns the number of commits after timestamp' do
        options = { ref: 'master', limit: nil, after: Time.iso8601('2013-03-03T20:15:01+00:00') }

        expect(repository.count_commits(options)).to eq(25)
      end
    end

    context 'with before timestamp' do
      it 'returns the number of commits after timestamp' do
        options = { ref: 'feature', limit: nil, before: Time.iso8601('2015-03-03T20:15:01+00:00') }

        expect(repository.count_commits(options)).to eq(9)
      end
    end

    context 'with path' do
      it 'returns the number of commits with path ' do
        options = { ref: 'master', limit: nil, path: "encoding" }

        expect(repository.count_commits(options)).to eq(2)
      end
    end
  end

      @repo = Gitlab::Git::Repository.new('default', TEST_MUTABLE_REPO_PATH)
      @repo = Gitlab::Git::Repository.new('default', TEST_MUTABLE_REPO_PATH)
      File.open(File.join(SEED_STORAGE_PATH, TEST_MUTABLE_REPO_PATH, '.git', 'config')) do |config_file|
  describe '#find_commits' do
    it 'should return a return a collection of commits' do
      commits = repository.find_commits
      expect(commits).not_to be_empty
      expect(commits).to all( be_a_kind_of(Gitlab::Git::Commit) )
    context 'while applying a sort order based on the `order` option' do
      it "allows ordering topologically (no parents shown before their children)" do
        expect_any_instance_of(Rugged::Walker).to receive(:sorting).with(Rugged::SORT_TOPO)
        repository.find_commits(order: :topo)
      it "allows ordering by date" do
        expect_any_instance_of(Rugged::Walker).to receive(:sorting).with(Rugged::SORT_DATE | Rugged::SORT_TOPO)
        repository.find_commits(order: :date)
      end
      it "applies no sorting by default" do
        expect_any_instance_of(Rugged::Walker).to receive(:sorting).with(Rugged::SORT_NONE)
        repository.find_commits
      end
  end
  describe '#branches with deleted branch' do
    before(:each) do
      ref = double()
      allow(ref).to receive(:name) { 'bad-branch' }
      allow(ref).to receive(:target) { raise Rugged::ReferenceError }
      allow(repository.rugged).to receive(:branches) { [ref] }
    it 'should return empty branches' do
      expect(repository.branches).to eq([])
  end
  describe '#branch_count' do
    it 'returns the number of branches' do
      expect(repository.branch_count).to eq(9)
    let(:attributes_path) { File.join(SEED_STORAGE_PATH, TEST_REPO_PATH, 'info/attributes') }
    info_dir_path = attributes_path = File.join(SEED_STORAGE_PATH, TEST_REPO_PATH, 'info')
      @repo = Gitlab::Git::Repository.new('default', TEST_MUTABLE_REPO_PATH)

  def stub_gitaly
    allow(Gitlab::GitalyClient).to receive(:feature_enabled?).and_return(true)

    stub = double(:stub)
    allow(Gitaly::Ref::Stub).to receive(:new).and_return(stub)
  end