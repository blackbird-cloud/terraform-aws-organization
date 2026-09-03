# The management-account contacts became optional (count-based) so existing
# state migrates from the un-indexed address to index [0] without recreation.
moved {
  from = aws_account_primary_contact.root
  to   = aws_account_primary_contact.root[0]
}

moved {
  from = aws_account_alternate_contact.root_operations
  to   = aws_account_alternate_contact.root_operations[0]
}

moved {
  from = aws_account_alternate_contact.root_billing
  to   = aws_account_alternate_contact.root_billing[0]
}

moved {
  from = aws_account_alternate_contact.root_security
  to   = aws_account_alternate_contact.root_security[0]
}
