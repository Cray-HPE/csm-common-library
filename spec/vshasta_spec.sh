Describe 'isgcp true'
  Include sh/vshasta.sh
  It "checks if a node is booted to a GCP image"
    When call isgcp .
      The output should eq ""
      The status should be success
    End
End

Describe 'isgcp false'
  Include sh/vshasta.sh
  It "checks if a node is booted to a GCP image"
  When call isgcp
    The output should eq ""
    The status should be failure
  End
End
