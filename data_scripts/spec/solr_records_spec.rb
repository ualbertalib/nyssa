require_relative "spec_helper"

describe SolrRecordSet do

  let(:solr_records){ SolrRecordSet.new(StringIO.new(single_record), "spec/data/test_match_data.txt") }

  context "given an sfx data file" do
    it "loads the specified data file into an hash of records" do
      expect(solr_records.list).to_not be_empty
    end
  end

  context "given a populated hash" do
   it "should have a list of Records" do
     expect(solr_records.list["0000-0019"]).to be_an_instance_of Record
   end
  end

  context "once the hash is populated" do
    let(:record){ double() }
    before :each do
      record.stub(:to_xml){"<doc><field name=\"id\">954921332001</field><field name=\"ua_sfx_object_id\">954921332001</field><field name=\"ua_issnPrint\">0000-0019</field><field name=\"ua_titleID\">5903768</field></doc>"}
    end

    it "should contain complete xml representations of records" do
      expect(solr_records.list["0000-0019"].to_xml).to eq record.to_xml
    end
  end

  context "when asked for a solr.xml file" do
    let(:solr_xml){ "<?xml version=\"1.0\" encoding=\"UTF-8\"?><add><doc><field name=\"id\">954921332001</field><field name=\"ua_sfx_object_id\">954921332001</field><field name=\"ua_issnPrint\">0000-0019</field><field name=\"ua_titleID\">5903768</field></doc></add>" }
    it "produces the right solr.xml records" do
      expect(solr_records.to_xml).to eq solr_xml
    end

    it "creates a solr.xml file" do
      File.delete("spec/data/test_solr.xml") if File.exist?("spec/data/test_solr.xml")
      solr_records.to_solr("spec/data/test_solr.xml")
      expect(File.open("spec/data/test_solr.xml").read.chomp).to eq solr_records.to_xml
    end
  end

let!(:single_record){ %[
<?xml version="1.0" encoding="UTF-8"?>

<collection xmlns="http://www.loc.gov/MARC21/slim">
 <!-- FIRST INCREMENTAL -->
 <!-- INSTANCE:sfxlcl41 -->
 <record>
  <leader>-----nas-a2200000z--4500</leader>
  <controlfield tag="008">131128uuuuuuuuuxx-uu-|------u|----|eng-d</controlfield>
  <datafield tag="010" ind1="" ind2="">
   <subfield code="a">01015589</subfield>
  </datafield>
  <datafield tag="245" ind1="" ind2="0">
   <subfield code="a">Publishers weekly</subfield>
  </datafield>
  <datafield tag="260" ind1="" ind2="">
   <subfield code="a">New York, NY</subfield>
   <subfield code="b">Reed Business Information</subfield>
  </datafield>
  <datafield tag="022" ind1="" ind2="">
   <subfield code="a">0000-0019</subfield>
  </datafield>
  <datafield tag="776" ind1="" ind2="">
   <subfield code="x">2150-4008</subfield>
  </datafield>
  <datafield tag="090" ind1="" ind2="">
   <subfield code="a">954921332001</subfield>
  </datafield>
  <datafield tag="866" ind1="" ind2="">
   <subfield code="a">Available from 1997. </subfield>
   <subfield code="b">$obj-&gt;parsedDate('&gt;=','1997',undef,undef)</subfield>
   <subfield code="c">L</subfield>
   <subfield code="s">1000000000002159</subfield>
   <subfield code="t">1000000000001505</subfield>
   <subfield code="x">Academic Search Complete:Full Text</subfield>
   <subfield code="z">1000000000671051</subfield>
  </datafield>
  <datafield tag="866" ind1="" ind2="">
   <subfield code="a">Available from 1997. </subfield>
   <subfield code="s">1000000000001224</subfield>
   <subfield code="t">1000000000000630</subfield>
   <subfield code="x">Business Source Complete:Full Text</subfield>
   <subfield code="z">1000000000125212</subfield>
  </datafield>
  <datafield tag="866" ind1="" ind2="">
   <subfield code="a">Available from 1997. </subfield>
   <subfield code="s">111038004962001</subfield>
   <subfield code="t">111038004962000</subfield>
   <subfield code="x">Canadian Reference Centre:Full Text</subfield>
   <subfield code="z">111038333129000</subfield>
  </datafield>
  <datafield tag="866" ind1="" ind2="">
   <subfield code="a">Available from 1997 until 2011. </subfield>
   <subfield code="s">3580000000000016</subfield>
   <subfield code="t">3580000000000013</subfield>
   <subfield code="x">EBSCOhost Library &amp; Information Science Source:Full Text</subfield>
   <subfield code="z">3580000000007640</subfield>
  </datafield>
  <datafield tag="866" ind1="" ind2="">
   <subfield code="a">Available from 1998. </subfield>
   <subfield code="s">3450000000000061</subfield>
   <subfield code="t">3450000000000049</subfield>
   <subfield code="x">EBSCOhost OmniFile Full Text Select:Full Text</subfield>
   <subfield code="z">3450000000028829</subfield>
  </datafield>
  <datafield tag="866" ind1="" ind2="">
   <subfield code="a">Available from 1997. </subfield>
   <subfield code="s">1000000000002115</subfield>
   <subfield code="t">1000000000001465</subfield>
   <subfield code="x">Education Research Complete:Full Text</subfield>
   <subfield code="z">1000000000715646</subfield>
  </datafield>
  <datafield tag="866" ind1="" ind2="">
   <subfield code="a">Available from 1994 until 2011. </subfield>
   <subfield code="s">111037301464002</subfield>
   <subfield code="t">111037301464000</subfield>
   <subfield code="x">Factiva:Full Text</subfield>
   <subfield code="z">111037302894000</subfield>
  </datafield>
  <datafield tag="866" ind1="" ind2="">
   <subfield code="a">Available from 1995 issue: 48. </subfield>
   <subfield code="s">110976638852341</subfield>
   <subfield code="t">110976638852340</subfield>
   <subfield code="x">Free E- Journals:Full Text</subfield>
   <subfield code="z">1000000000485631</subfield>
  </datafield>
  <datafield tag="866" ind1="" ind2="">
   <subfield code="a">Available from 2000 until 2002. </subfield>
   <subfield code="s">1000000000001286</subfield>
   <subfield code="t">1000000000000667</subfield>
   <subfield code="x">Gale Cengage Contemporary Women's Issues:Full Text</subfield>
   <subfield code="z">1000000000212221</subfield>
  </datafield>
  <datafield tag="866" ind1="" ind2="">
   <subfield code="a">Available from 1990. </subfield>
   <subfield code="s">111088000914001</subfield>
   <subfield code="t">111088000914000</subfield>
   <subfield code="x">Gale Cengage CPI.Q:Full Text</subfield>
   <subfield code="z">1000000001051952</subfield>
  </datafield>
  <datafield tag="866" ind1="" ind2="">
   <subfield code="a">Available from 1990. </subfield>
   <subfield code="s">111031861479000</subfield>
   <subfield code="t">111031861411000</subfield>
   <subfield code="x">Gale Cengage Literature Resource Center:Full Text</subfield>
   <subfield code="z">111031861902000</subfield>
  </datafield>
  <datafield tag="866" ind1="" ind2="">
   <subfield code="a">Available from 1997. </subfield>
   <subfield code="s">1000000000002160</subfield>
   <subfield code="t">1000000000001506</subfield>
   <subfield code="x">Literary Reference Center:Full Text</subfield>
   <subfield code="z">1000000000666804</subfield>
  </datafield>
  <datafield tag="866" ind1="" ind2="">
   <subfield code="a">Available from 1997. </subfield>
   <subfield code="s">110976114395371</subfield>
   <subfield code="t">110976114395369</subfield>
   <subfield code="x">MasterFILE Premier:Full Text</subfield>
   <subfield code="z">111013713707002</subfield>
  </datafield>
  <datafield tag="866" ind1="" ind2="">
   <subfield code="a">Available from 1997. </subfield>
   <subfield code="s">110976039380296</subfield>
   <subfield code="t">110976039380294</subfield>
   <subfield code="x">MAS Ultra - School Edition:Full Text</subfield>
   <subfield code="z">111069624483000</subfield>
  </datafield>
  <datafield tag="866" ind1="" ind2="">
   <subfield code="a">Available from 1996. </subfield>
   <subfield code="s">2400000000000006</subfield>
   <subfield code="t">2400000000000006</subfield>
   <subfield code="x">ProQuest ABI/INFORM Global New Platform:Full Text</subfield>
   <subfield code="z">2550000000127122</subfield>
  </datafield>
  <datafield tag="650" ind1="" ind2="4">
   <subfield code="a">Information Technology</subfield>
   <subfield code="x">Information Science and Systems</subfield>
  </datafield>
  <datafield tag="650" ind1="" ind2="4">
   <subfield code="a">Library and Information Sciences</subfield>
   <subfield code="x">General and Others</subfield>
  </datafield>
 </record>
 </collection>]}
end
