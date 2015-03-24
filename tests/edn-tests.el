(require 'ert)
(require 'edn)

(ert-deftest whitespace ()
  :tags '(edn)
  (should (null (edn-parse "")))
  (should (null (edn-parse " ")))
  (should (null (edn-parse "   ")))
  (should (null (edn-parse "	")))
  (should (null (edn-parse "		")))
  (should (null (edn-parse ",")))
  (should (null (edn-parse ",,,,")))
  (should (null (edn-parse "	  , ,
")))
  (should (null (edn-parse"
  ,, 	"))))

(ert-deftest symbols ()
  :tags '(edn symbol)
  (should (equal 'foo (edn-parse "foo")))
  (should (equal 'foo\. (edn-parse "foo.")))
  (should (equal '%foo\. (edn-parse "%foo.")))
  (should (equal 'foo/bar (edn-parse "foo/bar")))
  (equal 'some\#sort\#of\#symbol (edn-parse "some#sort#of#symbol"))
  (equal 'truefalse (edn-parse "truefalse"))
  (equal 'true. (edn-parse "true."))
  (equal '/ (edn-parse "/"))
  (should (equal '.true (edn-parse ".true")))
  (should (equal 'some:sort:of:symbol (edn-parse "some:sort:of:symbol")))
  (equal 'foo-bar (edn-parse "foo-bar")))

(ert-deftest booleans ()
  :tags '(edn boolean)
  (should (equal t (edn-parse "true")))
  (should (equal nil (edn-parse "false "))))

(ert-deftest characters ()
  :tags '(edn characters)
  (should (equal 97 (edn-parse "\\a")))
  (should (equal 960 (edn-parse "\\u03C0")))
  (should (equal 'newline (edn-parse "\\newline"))))

(ert-deftest elision ()
  :tags '(edn elision)
  (should-not (edn-parse "#_foo"))
  (should-not (edn-parse "#_ 123"))
  (should-not (edn-parse "#_ \\a"))
  (should-not (edn-parse "#_
\"foo\"")))

(ert-deftest string ()
  :tags '(edn string)
  (should (equal "this is a string" (edn-parse "\"this is a string\"")))
  (should (equal "this has an escaped \"quote in it"
                 (edn-parse "\"this has an escaped \\\"quote in it\"")))
  (should (equal "foo\\tbar" (edn-parse "\"foo\\tbar\"")))
  (should (equal "foo\\nbar" (edn-parse "\"foo\\nbar\"")))
  (should (equal "this is a string \\ that has an escaped backslash"
                 (edn-parse "\"this is a string \\\\ that has an escaped backslash\"")))
  (should (equal "[" (edn-parse "\"[\""))))

(ert-deftest keywords ()
  :tags '(edn keywords)
  (should (equal :namespace\.of\.some\.length/keyword-name
                 (edn-parse ":namespace.of.some.length/keyword-name")))
  (should (equal :\#/\# (edn-parse ":#/#")))
  (should (equal :\#/:a (edn-parse ":#/:a")))
  (should (equal :\#foo (edn-parse ":#foo"))))

(defmacro testing (what &rest examples)
  `(ert-deftest ,what ()
     (tag (edn ,what))
     ,@(mapcar (lambda (ex)
                 `(should (equal ,(first ex) ,(second ex))))
               examples)))

(ert-deftest integers nil
  (tag '(edn integers))
  (should (= 0 (edn-parse "0")))
  (should (= 0 (edn-parse "+0")))
  (should (= 0 (edn-parse "-0")))
  (should (= 100 (edn-parse "100")))
  (should (= -100 (edn-parse "-100"))))
