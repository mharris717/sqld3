#!/usr/bin/env ruby

# Process the sql-bubble.txt into a ruby rules.
#
bubble = ARGV[0] || 'sql-bubble.txt'

lines = File.open(bubble, "r").readlines
lines = lines.reject {|x| x.match(/^\s*\#/)} # Comments.
lines = lines.reject {|x| x.match(/^\s*$/)}  # Whitespace.
lines = lines.map {|x| x.gsub(/^set all_graphs \{/, '')}
lines = lines.map {|x| x.gsub(/^\}/, 'nil')}
lines = lines.map {|x| x.gsub(/\{\}/, 'nil')}
lines = lines.map {|x| x.gsub(/\./, 'dot')}
lines = lines.map {|x| x.gsub(/\=/, 'equal')}
lines = lines.map {|x| x.gsub(/\-\-/, 'minusminus')}
lines = lines.map {|x| x.gsub(/ \-/, ' minus')}
lines = lines.map {|x| x.gsub(/\+/, 'plus')}
lines = lines.map {|x| x.gsub(/\-/, '_')}
lines = lines.map {|x| x.gsub(/,/, 'comma')}
lines = lines.map {|x| x.gsub(/\/\*/, 'comment_beg')}
lines = lines.map {|x| x.gsub(/\*\//, 'comment_end')}
lines = lines.map {|x| x.gsub(/\*/, 'star')}
lines = lines.map {|x| x.gsub(/\;/, 'semicolon')}
lines = lines.map {|x| x.gsub(/\(/, 'lparen')}
lines = lines.map {|x| x.gsub(/\)/, 'rparen')}
lines = lines.map {|x| x.gsub(/\{/, '(')}
lines = lines.map {|x| x.gsub(/\}/, ')')}
lines = lines.map {|x| x.gsub(/\//, '')}
lines = lines.map {|x| x.gsub(/([A-Z][A-Z_]*)/, '"\\1"')}
lines = lines.map {|x| x.gsub(/([a-z][a-z_]+)/, ':\\1')}
lines = lines.map {|x| x.gsub(/^  \)/, '  ))')}

c = lines.join("")

if true
  c = c.gsub(/\(\s*:toploop ?/, "toploop( ")
  c = c.gsub(/\(\s*:tailbranch ?/, "tailbranch( ")
  c = c.gsub(/\(\s*:opt(x?) ?/, "opt\\1( ")
  c = c.gsub(/\(\s*:or ?/, "either( ")
  c = c.gsub(/\(\s*:line ?/, "line( ")
  c = c.gsub(/\(\s*:loop ?/, "loop( ")
  c = c.gsub(/\(\s*:stack ?/, "stack( ")
  c = c.gsub(/\"(\s+)/, "\",\\1")
  c = c.gsub(/([a-z])(\s+)/, "\\1,\\2")
  c = c.gsub(/\)/, "),\\1")
  c = c.gsub(/,(\s*)\)/, "\\1)")
  c = c.gsub(/  \)\),/, "  ))")
  c = c.gsub(/, \(:nil,/, ", line(:nil,")
end

lines = c.split("\n")
lines = lines.map {|x| x.gsub(/^  ([a-z_:]+)/, '  rule( \\1')}

print "# generated by './sql-bubble.rb #{bubble}'\n"
print lines[0..-2].join("\n")
print "\n"

