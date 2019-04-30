{
  actionpack = {
    dependencies = ["actionview" "activesupport" "rack" "rack-test" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rmldsk3a4lwxk0lrp6x1nz1v1r2xmbm3300l4ghgfygv3grdwjh";
      type = "gem";
    };
    version = "4.2.11.1";
  };
  actionview = {
    dependencies = ["activesupport" "builder" "erubis" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0x7vjn8q6blzyf7j3kwg0ciy7vnfh28bjdkd1mp9k4ghp9jn0g9p";
      type = "gem";
    };
    version = "4.2.11.1";
  };
  activemodel = {
    dependencies = ["activesupport" "builder"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c1x0rd6wnk1f0gsmxs6x3gx7yf6fs9qqkdv7r4hlbcdd849in33";
      type = "gem";
    };
    version = "4.2.11.1";
  };
  activerecord = {
    dependencies = ["activemodel" "activesupport" "arel"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07ixiwi0zzs9skqarvpfamsnay7npfswymrn28ngxaf8hi279q5p";
      type = "gem";
    };
    version = "4.2.11.1";
  };
  activesupport = {
    dependencies = ["i18n" "minitest" "thread_safe" "tzinfo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vbq7a805bfvyik2q3kl9s3r418f5qzvysqbz2cwy4hr7m2q4ir6";
      type = "gem";
    };
    version = "4.2.11.1";
  };
  addressable = {
    dependencies = ["public_suffix"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0viqszpkggqi8hq87pqp0xykhvz60g99nwmkwsb0v45kc2liwxvk";
      type = "gem";
    };
    version = "2.5.2";
  };
  afm = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06kj9hgd0z8pj27bxp2diwqh6fv7qhwwm17z64rhdc4sfn76jgn8";
      type = "gem";
    };
    version = "0.2.2";
  };
  arel = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nfcrdiys6q6ylxiblky9jyssrw2xj96fmxmal7f4f0jj3417vj4";
      type = "gem";
    };
    version = "6.0.4";
  };
  arel-helpers = {
    dependencies = ["activerecord"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qj4iljnsyp2ljdcw4ihi2lsj752h4xn3qw7qk6q7q5i5n0syfk3";
      type = "gem";
    };
    version = "2.8.0";
  };
  Ascii85 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0658m37jjjn6drzqg1gk4p6c205mgp7g1jh2d00n4ngghgmz5qvs";
      type = "gem";
    };
    version = "1.0.3";
  };
  backports = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17j5pf0b69bkn043wi4xd530ky53jbbnljr4bsjzlm4k8bzlknfn";
      type = "gem";
    };
    version = "3.14.0";
  };
  bcrypt = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ysblqxkclmnhrd0kmb5mr8p38mbar633gdsb14b7dhkhgawgzfy";
      type = "gem";
    };
    version = "3.1.12";
  };
  bcrypt_pbkdf = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02vssr285m7kpsr47jdmzbar1h1d0mnkmyrpr1zg828isfmwii35";
      type = "gem";
    };
    version = "1.0.1";
  };
  bindata = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kz42nvxnk1j9cj0i8lcnhprcgdqsqska92g6l19ziadydfk2gqy";
      type = "gem";
    };
    version = "2.4.4";
  };
  bit-struct = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w7x1fh4a6inpb46imhdf4xrq0z4d6zdpg7sdf8n98pif2hx50sx";
      type = "gem";
    };
    version = "0.16";
  };
  builder = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qibi5s67lpdv1wgcj66wcymcr04q6j4mzws6a479n0mlrmh5wr1";
      type = "gem";
    };
    version = "3.2.3";
  };
  concurrent-ruby = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "183lszf5gx84kcpb779v6a2y0mx9sssy8dgppng1z9a505nj1qcf";
      type = "gem";
    };
    version = "1.0.5";
  };
  crass = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bpxzy6gjw9ggjynlxschbfsgmx8lv3zw1azkjvnb8b9i895dqfi";
      type = "gem";
    };
    version = "1.0.4";
  };
  dnsruby = {
    dependencies = ["addressable"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04sxvjif1pxmlf02mj3hkdb209pq18fv9sr2p0mxwi0dpifk6f3x";
      type = "gem";
    };
    version = "1.61.2";
  };
  ed25519 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1f5kr8za7hvla38fc0n9jiv55iq62k5bzclsa5kdb14l3r4w6qnw";
      type = "gem";
    };
    version = "1.2.4";
  };
  erubis = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fj827xqjs91yqsydf0zmfyw9p4l2jz5yikg3mppz6d7fi8kyrb3";
      type = "gem";
    };
    version = "2.7.0";
  };
  faker = {
    dependencies = ["i18n"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vslyqmk9gjvp1ahyfqmwy1jcyv75rp88hxwpy7cdk2lpdb1jp3l";
      type = "gem";
    };
    version = "1.9.3";
  };
  faraday = {
    dependencies = ["multipart-post"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s72m05jvzc1pd6cw1i289chas399q0a14xrwg4rvkdwy7bgzrh0";
      type = "gem";
    };
    version = "0.15.4";
  };
  filesize = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17p7rf1x7h3ivaznb4n4kmxnnzj25zaviryqgn2n12v2kmibhp8g";
      type = "gem";
    };
    version = "0.2.0";
  };
  hashery = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qj8815bf7q6q7llm5rzdz279gzmpqmqqicxnzv066a020iwqffj";
      type = "gem";
    };
    version = "2.1.2";
  };
  i18n = {
    dependencies = ["concurrent-ruby"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "038qvz7kd3cfxk8bvagqhakx68pfbnmghpdkx7573wbf0maqp9a3";
      type = "gem";
    };
    version = "0.9.5";
  };
  jsobfu = {
    dependencies = ["rkelly-remix"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hchns89cfj0gggm2zbr7ghb630imxm2x2d21ffx2jlasn9xbkyk";
      type = "gem";
    };
    version = "0.4.2";
  };
  json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sx97bm9by389rbzv8r1f43h06xcz8vwi3h5jv074gvparql7lcx";
      type = "gem";
    };
    version = "2.2.0";
  };
  loofah = {
    dependencies = ["crass" "nokogiri"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ccsid33xjajd0im2xv941aywi58z7ihwkvaf1w2bv89vn5bhsjg";
      type = "gem";
    };
    version = "2.2.3";
  };
  metasm = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mbmpc8vsi574s78f23bhiqk07sr6yrrrmk702lfv61ql4ah5l89";
      type = "gem";
    };
    version = "1.0.4";
  };
  metasploit-concern = {
    dependencies = ["activemodel" "activesupport" "railties"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v9lm225fhzhnbjcc0vwb38ybikxwzlv8116rrrkndzs8qy79297";
      type = "gem";
    };
    version = "2.0.5";
  };
  metasploit-credential = {
    dependencies = ["metasploit-concern" "metasploit-model" "metasploit_data_models" "pg" "railties" "rex-socket" "rubyntlm" "rubyzip"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "196xzphlqfivrrdw9cqwjvrz0m53xn103l4snsw7mis20vm6hn9v";
      type = "gem";
    };
    version = "2.0.14";
  };
  metasploit-framework = {
    dependencies = ["actionpack" "activerecord" "activesupport" "backports" "bcrypt" "bcrypt_pbkdf" "bit-struct" "concurrent-ruby" "dnsruby" "ed25519" "faker" "filesize" "jsobfu" "json" "metasm" "metasploit-concern" "metasploit-credential" "metasploit-model" "metasploit-payloads" "metasploit_data_models" "metasploit_payloads-mettle" "mqtt" "msgpack" "nessus_rest" "net-ssh" "network_interface" "nexpose" "nokogiri" "octokit" "openssl-ccm" "openvas-omp" "packetfu" "patch_finder" "pcaprub" "pdf-reader" "pg" "railties" "rb-readline" "recog" "redcarpet" "rex-arch" "rex-bin_tools" "rex-core" "rex-encoder" "rex-exploitation" "rex-java" "rex-mime" "rex-nop" "rex-ole" "rex-powershell" "rex-random_identifier" "rex-registry" "rex-rop_builder" "rex-socket" "rex-sslscan" "rex-struct2" "rex-text" "rex-zip" "ruby-macho" "ruby_smb" "rubyntlm" "rubyzip" "sqlite3" "sshkey" "tzinfo" "tzinfo-data" "windows_error" "xdr" "xmlrpc"];
    groups = ["default"];
    platforms = [];
    source = {
      fetchSubmodules = false;
      rev = "96fbe83c3c27a5514d6db05ab85aedbbef19bb60";
      sha256 = "1g17k35p2l57pjhik5ql7smrgv7jgns5af0a9jhwqm98apb3lhbv";
      type = "git";
      url = "https://github.com/rapid7/metasploit-framework";
    };
    version = "4.17.54";
  };
  metasploit-model = {
    dependencies = ["activemodel" "activesupport" "railties"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05pnai1cv00xw87rrz38dz4s3ss45s90290d0knsy1mq6rp8yvmw";
      type = "gem";
    };
    version = "2.0.4";
  };
  metasploit-payloads = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qraa833prw35134676g5cy245bpiz6ycfjs5dbki0xfcxy65fcc";
      type = "gem";
    };
    version = "1.3.66";
  };
  metasploit_data_models = {
    dependencies = ["activerecord" "activesupport" "arel-helpers" "metasploit-concern" "metasploit-model" "pg" "postgres_ext" "railties" "recog"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wfg6qph53gi83k3wa9dgvndm56g8cg8avl90fnsidpc2cvbmx4f";
      type = "gem";
    };
    version = "2.0.17";
  };
  metasploit_payloads-mettle = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ycgyn8sgjz5x2d7ya3x0lxifxfz23n79dbwjfpk3qb0dl5xbq0l";
      type = "gem";
    };
    version = "0.5.12";
  };
  mini_portile2 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15zplpfw3knqifj9bpf604rb3wc1vhq6363pd6lvhayng8wql5vy";
      type = "gem";
    };
    version = "2.4.0";
  };
  minitest = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0icglrhghgwdlnzzp4jf76b0mbc71s80njn5afyfjn4wqji8mqbq";
      type = "gem";
    };
    version = "5.11.3";
  };
  mqtt = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0d1khsry5mf63y03r6v91f4vrbn88277ksv7d69z3xmqs9sgpri9";
      type = "gem";
    };
    version = "0.5.0";
  };
  msgpack = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w38hilm3dk42dwk8ygiq49bl4in7y80hfqr63hk54mj4gmzi6ch";
      type = "gem";
    };
    version = "1.2.10";
  };
  multipart-post = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09k0b3cybqilk1gwrwwain95rdypixb2q9w65gd44gfzsd84xi1x";
      type = "gem";
    };
    version = "2.0.0";
  };
  nessus_rest = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1allyrd4rll333zbmsi3hcyg6cw1dhc4bg347ibsw191nswnp8ci";
      type = "gem";
    };
    version = "0.1.6";
  };
  net-ssh = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "101wd2px9lady54aqmkibvy4j62zk32w0rjz4vnigyg974fsga40";
      type = "gem";
    };
    version = "5.2.0";
  };
  network_interface = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xh4knfq77ii4pjzsd2z1p3nd6nrcdjhb2vi5gw36jqj43ffw0zp";
      type = "gem";
    };
    version = "0.0.2";
  };
  nexpose = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i108glkklwgjxhfhnlqf4b16plqf9b84qpfz0pnl2pbnal5af8m";
      type = "gem";
    };
    version = "7.2.1";
  };
  nokogiri = {
    dependencies = ["mini_portile2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02bjydih0j515szfv9mls195cvpyidh6ixm7dwbl3s2sbaxxk5s4";
      type = "gem";
    };
    version = "1.10.3";
  };
  octokit = {
    dependencies = ["sawyer"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w7agbfg39jzqk81yad9xhscg31869277ysr2iwdvpjafl5lj4ha";
      type = "gem";
    };
    version = "4.14.0";
  };
  openssl-ccm = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gxwxk657jya2s5m8cpckvgy5m7qx0hzfp8xvc0hg2wf1lg5gwp0";
      type = "gem";
    };
    version = "1.2.2";
  };
  openvas-omp = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14xf614vd76qjdjxjv14mmjar6s64fwp4cwb7bv5g1wc29srg28x";
      type = "gem";
    };
    version = "0.0.4";
  };
  packetfu = {
    dependencies = ["pcaprub"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16ppq9wfxq4x2hss61l5brs3s6fmi8gb50mnp1nnnzb1asq4g8ll";
      type = "gem";
    };
    version = "1.1.13";
  };
  patch_finder = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1md9scls55n1riw26vw1ak0ajq38dfygr36l0h00wqhv51cq745m";
      type = "gem";
    };
    version = "1.0.2";
  };
  pcaprub = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h4iarqdych6v4jm5s0ywkc01qspadz8sf6qn7pkqmszq4iqv67q";
      type = "gem";
    };
    version = "0.13.0";
  };
  pdf-reader = {
    dependencies = ["Ascii85" "afm" "hashery" "ruby-rc4" "ttfunk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0aas2f5clgwpgryywrh4gihdi10afx3kbyfs1n31cinri02psd43";
      type = "gem";
    };
    version = "2.2.0";
  };
  pg = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00vhasqwc4f98qb4wxqn2h07fjwzhp5lwyi41j2gndi2g02wrdqh";
      type = "gem";
    };
    version = "0.21.0";
  };
  pg_array_parser = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1034dhg8h53j48sfm373js54skg4vpndjga6hzn2zylflikrrf3s";
      type = "gem";
    };
    version = "0.0.9";
  };
  postgres_ext = {
    dependencies = ["activerecord" "arel" "pg_array_parser"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ni1ajzxvc17ba4rgl27cd3645ddbpqpfckv7m08sfgk015hh7dq";
      type = "gem";
    };
    version = "3.0.1";
  };
  public_suffix = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08q64b5br692dd3v0a9wq9q5dvycc6kmiqmjbdxkxbfizggsvx6l";
      type = "gem";
    };
    version = "3.0.3";
  };
  rack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g9926ln2lw12lfxm4ylq1h6nl0rafl10za3xvjzc87qvnqic87f";
      type = "gem";
    };
    version = "1.6.11";
  };
  rack-test = {
    dependencies = ["rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h6x5jq24makgv2fq5qqgjlrk74dxfy62jif9blk43llw8ib2q7z";
      type = "gem";
    };
    version = "0.6.3";
  };
  rails-deprecated_sanitizer = {
    dependencies = ["activesupport"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qxymchzdxww8bjsxj05kbf86hsmrjx40r41ksj0xsixr2gmhbbj";
      type = "gem";
    };
    version = "1.0.3";
  };
  rails-dom-testing = {
    dependencies = ["activesupport" "nokogiri" "rails-deprecated_sanitizer"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wssfqpn00byhvp2372p99mphkcj8qx6pf6646avwr9ifvq0q1x6";
      type = "gem";
    };
    version = "1.0.9";
  };
  rails-html-sanitizer = {
    dependencies = ["loofah"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gv7vr5d9g2xmgpjfq4nxsqr70r9pr042r9ycqqnfvw5cz9c7jwr";
      type = "gem";
    };
    version = "1.0.4";
  };
  railties = {
    dependencies = ["actionpack" "activesupport" "rake" "thor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bjf21z9maiiazc1if56nnh9xmgbkcqlpznv34f40a1hsvgk1d1m";
      type = "gem";
    };
    version = "4.2.11.1";
  };
  rake = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sy5a7nh6xjdc9yhcw31jji7ssrf9v5806hn95gbrzr998a2ydjn";
      type = "gem";
    };
    version = "12.3.2";
  };
  rb-readline = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14w79a121czmvk1s953qfzww30mqjb2zc0k9qhi0ivxxk3hxg6wy";
      type = "gem";
    };
    version = "0.5.5";
  };
  recog = {
    dependencies = ["nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02nshgak2m2q7i1cjlxj9rhjn9r0s0ms8g8747wx1mqwcxajhr5a";
      type = "gem";
    };
    version = "2.3.0";
  };
  redcarpet = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h9qz2hik4s9knpmbwrzb3jcp3vc5vygp9ya8lcpl7f1l9khmcd7";
      type = "gem";
    };
    version = "3.4.0";
  };
  rex-arch = {
    dependencies = ["rex-text"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cvdy2ysiphdig258lkicbxqq2y47bkl69kgj4kkj8w338rb5kwa";
      type = "gem";
    };
    version = "0.1.13";
  };
  rex-bin_tools = {
    dependencies = ["metasm" "rex-arch" "rex-core" "rex-struct2" "rex-text"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19q4cj7cis29k3zx9j2gp4h3ib0zig2fa4rs56c1gjr32f192zzk";
      type = "gem";
    };
    version = "0.1.6";
  };
  rex-core = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1b9pf7f8m2zjck65dpp8h8v4n0a05kfas6cn9adv0w8d9z58aqvv";
      type = "gem";
    };
    version = "0.1.13";
  };
  rex-encoder = {
    dependencies = ["metasm" "rex-arch" "rex-text"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zm5jdxgyyp8pkfqwin34izpxdrmglx6vmk20ifnvcsm55c9m70z";
      type = "gem";
    };
    version = "0.1.4";
  };
  rex-exploitation = {
    dependencies = ["jsobfu" "metasm" "rex-arch" "rex-encoder" "rex-text"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gzmxi4v5q44f12mfqaz223w9vnndjqraabrkgdm8w2i76v0sw9z";
      type = "gem";
    };
    version = "0.1.20";
  };
  rex-java = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j58k02p5g9snkpak64sb4aymkrvrh9xpqh8wsnya4w7b86w2y6i";
      type = "gem";
    };
    version = "0.1.5";
  };
  rex-mime = {
    dependencies = ["rex-text"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15a14kz429h7pn81ysa6av3qijxjmxagjff6dyss5v394fxzxf4a";
      type = "gem";
    };
    version = "0.1.5";
  };
  rex-nop = {
    dependencies = ["rex-arch"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0aigf9qsqsmiraa6zvfy1a7cyvf7zc3iyhzxi6fjv5sb8f64d6ny";
      type = "gem";
    };
    version = "0.1.1";
  };
  rex-ole = {
    dependencies = ["rex-text"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pnzbqfnvbs0vc0z0ryszk3fxhgxrjd6gzwqa937rhlphwp5jpww";
      type = "gem";
    };
    version = "0.1.6";
  };
  rex-powershell = {
    dependencies = ["rex-random_identifier" "rex-text"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fcyiz8cgcv6pcn5w969ac4wwhr1cz6jk6kf6p8gyw5rjrlwfz0j";
      type = "gem";
    };
    version = "0.1.82";
  };
  rex-random_identifier = {
    dependencies = ["rex-text"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fg94sczff5c2rlvqqgw2dndlqyzjil5rjk3p9f46ss2hc8zxlbk";
      type = "gem";
    };
    version = "0.1.4";
  };
  rex-registry = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wv812ghnz143vx10ixmv32ypj1xrzr4rh4kgam8d8wwjwxsgw1q";
      type = "gem";
    };
    version = "0.1.3";
  };
  rex-rop_builder = {
    dependencies = ["metasm" "rex-core" "rex-text"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xjd3d6wnbq4ym0d0m268md8fb16f2hbwrahvxnl14q63fj9i3wy";
      type = "gem";
    };
    version = "0.1.3";
  };
  rex-socket = {
    dependencies = ["rex-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "136szyv31fcdzmcgs44vg009k3ssyawkqppkhm3xyv2ivpp1mlgv";
      type = "gem";
    };
    version = "0.1.17";
  };
  rex-sslscan = {
    dependencies = ["rex-core" "rex-socket" "rex-text"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06gbx45q653ajcx099p0yxdqqxazfznbrqshd4nwiwg1p498lmyx";
      type = "gem";
    };
    version = "0.1.5";
  };
  rex-struct2 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nbdn53264a20cr2m2nq2v4mg0n33dvrd1jj1sixl37qjzw2k452";
      type = "gem";
    };
    version = "0.1.2";
  };
  rex-text = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w2ndcxkbn6f43504l5wss2j8q1s38vi2d7iml37cdvy1gwrczm8";
      type = "gem";
    };
    version = "0.2.21";
  };
  rex-zip = {
    dependencies = ["rex-text"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mbfryyhcw47i7jb8cs8vilbyqgyiyjkfl1ngl6wdbf7d87dwdw7";
      type = "gem";
    };
    version = "0.1.3";
  };
  rkelly-remix = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g7hjl9nx7f953y7lncmfgp0xgxfxvgfm367q6da9niik6rp1y3j";
      type = "gem";
    };
    version = "0.0.7";
  };
  ruby-macho = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k5vvk9d13pixhbram6fs74ibgmr2dngv7bks13npcjb42q275if";
      type = "gem";
    };
    version = "2.2.0";
  };
  ruby-rc4 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00vci475258mmbvsdqkmqadlwn6gj9m01sp7b5a3zd90knil1k00";
      type = "gem";
    };
    version = "0.1.5";
  };
  ruby_smb = {
    dependencies = ["bindata" "rubyntlm" "windows_error"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kx0q0wqfzgiccjqin2mp04bdk5jyyz4fnm78m1d5p3d9zqvi6v1";
      type = "gem";
    };
    version = "1.0.5";
  };
  rubyntlm = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p6bxsklkbcqni4bcq6jajc2n57g0w5rzn4r49c3lb04wz5xg0dy";
      type = "gem";
    };
    version = "0.6.2";
  };
  rubyzip = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1n1lb2sdwh9h27y244hxzg1lrxxg2m53pk1vq7p33bna003qkyrj";
      type = "gem";
    };
    version = "1.2.2";
  };
  sawyer = {
    dependencies = ["addressable" "faraday"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sv1463r7bqzvx4drqdmd36m7rrv6sf1v3c6vswpnq3k6vdw2dvd";
      type = "gem";
    };
    version = "0.8.1";
  };
  sqlite3 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v903nbcws3ifm6jnxrdfcpgl1qg2x3lbif16mhlbyfn0npzb494";
      type = "gem";
    };
    version = "1.4.1";
  };
  sshkey = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03bkn55qsng484iqwz2lmm6rkimj01vsvhwk661s3lnmpkl65lbp";
      type = "gem";
    };
    version = "2.0.0";
  };
  thor = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yhrnp9x8qcy5vc7g438amd5j9sw83ih7c30dr6g6slgw9zj3g29";
      type = "gem";
    };
    version = "0.20.3";
  };
  thread_safe = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nmhcgq6cgz44srylra07bmaw99f5271l0dpsvl5f75m44l0gmwy";
      type = "gem";
    };
    version = "0.3.6";
  };
  ttfunk = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mgrnqla5n51v4ivn844albsajkck7k6lviphfqa8470r46c58cd";
      type = "gem";
    };
    version = "1.5.1";
  };
  tzinfo = {
    dependencies = ["thread_safe"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fjx9j327xpkkdlxwmkl3a8wqj7i4l4jwlrv3z13mg95z9wl253z";
      type = "gem";
    };
    version = "1.2.5";
  };
  tzinfo-data = {
    dependencies = ["tzinfo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1105fp27d527k7rrq1yx1ikbzf1sra046ndayxikkjvay9ql61jz";
      type = "gem";
    };
    version = "1.2019.1";
  };
  windows_error = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kbcv9j5sc7pvjzf1dkp6h69i6lmj205zyy2arxcfgqg11bsz2kp";
      type = "gem";
    };
    version = "0.1.2";
  };
  xdr = {
    dependencies = ["activemodel" "activesupport"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c5cp1k4ij3xq1q6fb0f6xv5b65wy18y7bhwvsdx8wd0zyg3x96m";
      type = "gem";
    };
    version = "2.0.0";
  };
  xmlrpc = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s744iwblw262gj357pky3d9fcx9hisvla7rnw29ysn5zsb6i683";
      type = "gem";
    };
    version = "0.3.0";
  };
}
