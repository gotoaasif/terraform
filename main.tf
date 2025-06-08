# This is the terraform configuration file. This is where terraform looks
# for the actions that it needs to do


resource "local_file" "first_file_created_using_terraform" {
  filename = "first_file_created_using_terraform.txt"
  content  = "I am the first file created using terraform"
}

# Below code explains how to use an "Interpolation sequence" using ${}.
# The petname will be referred to in creation of the file and requires 
# it to be created before.
# This is called "Implicit dependency" where Terraform understands the 
# sequence of execution and creates the dependent resource i.e. petname first
# as that will be needed in the file content
# before it creates the file.

resource "local_file" "interpolat_seq" {
  #default = "interpolat_seq.txt"
  filename = "interpolat_seq.txt"
  #content  = "my pet name is ${random_pet.my_petname.id}"
  # ** Commented the above line to show that when
  # we do not have a dependency, TF creates resources randomly**
  content  = "my pet name is snowy"
}

# Below code helps understand how a variable is used
# Note that there is a variables.tf file that is being referenced

resource "local_file" "file_created_using_var" {
  filename = var.var_filename
  content = var.var_filecontent
}

# Below code highlights the *create_before_destroy* *lifecycle rule*.
# This is used to create a resource before deletion

resource "random_pet" "my_petnameX" {
  length    = 2
  prefix    = "Mr"
  separator = "_X_"
  lifecycle {
    create_before_destroy = true
  }
}

# Creating a new resource with explicit dependency
# In below case, my_petname_new will be created AFTER my_petname
resource "random_pet" "my_petname_new" {
  length    = 3
  prefix    = "Mrs"
  separator = "_new_"

  depends_on = [
    random_pet.my_petnameX
  ]
  }

# Creating a new resource to demo both explicit AND implicit dependency
# In below case, a new file that uses my_petname_new will be created AFTER my_petname
resource "local_file" "file_that_uses_my_petname_new" {
  filename = "file_that_uses_my_petname_new.txt"
  content  = "I depend upon the petname_new which is ${random_pet.my_petname_new.id}"
# Explicit dependency below
  depends_on = [
    random_pet.my_petname_depends
  ]
}

# Creating a new resource on which the explicit part of the Implicit and Explicit example depends
# In below case, my_petname_depends will be created BEFORE my_petname_new
resource "random_pet" "my_petname_depends" {
  length    = 2
  prefix    = "Miss"
  separator = "_dep_"
}

/*
In Terraform, the count meta-argument is a powerful tool that allows you to create multiple 
identical instances of a resource or module without having to duplicate the resource block in your configuration.
Instead of writing separate blocks for each instance, you define one block and tell Terraform how many copies to create.

How count Works
When you include the count meta-argument in a resource or module block, Terraform will create 
that many instances of the defined resource. The value of count must be a whole number 
(integer) and known before Terraform performs any remote resource actions 
(i.e., during the plan phase). This means you cannot use dynamic values 
that are only known after resources are created (like an auto-generated ID from an AWS EC2 instance).

Crucially, when count is used:

Indexed Instances: Terraform automatically creates an ordered list of resource instances, 
identified by an index number starting from 0. So, if count = 3, you'll have resource_type.resource_name[0],
 resource_type.resource_name[1], and resource_type.resource_name[2].
*/

# Creating several resources using count meta argument
# Also using count.index to automatically read the count

resource "local_file" "greek_alphabets" {
  count = 3
  filename = var.var_filename_list[count.index] # We need to pass the count.index arg when we ask TF to read from a list
  content = "files named by starting greek alphabets"
}

resource "local_file" "greek_alphabets_2" {
  count = length(var.var_filename_list_2) # To avoid hardcoding count value, use length() func. Its better coding practice 
                                          # to auto read
  filename = var.var_filename_list_2[count.index]
  content = "files named by middle greek alphabets"
}

/*
When to Use count vs. for_each
It's important to differentiate count from for_each.

count is best for:
Identical or nearly identical resources: When the resources are mostly the same,
 and any differences can be derived directly from the count.index
  (e.g., sequential naming, slight variations in configuration).

Conditional creation: When you need to create a resource (or not create it) based on a
 simple boolean condition, setting count to 1 or 0 is a common pattern.

for_each is best for:
Non-identical resources: When you need to create multiple resources that have 
distinctly different configurations, especially if those configurations come from a map
 or set of strings. for_each uses keys (from a map or set) to identify instances, 
 making it more robust against changes in the middle of a list compared to count's index-based identification.
IMP: If you remove an element from a list used with count, 
  all subsequent resources might be re-created or updated, which is often undesirable.
*/