# This is the terraform variables file

variable "var_filename" {
    default = "file_created using_var.txt"
    type = string
    description = "This file is created using variables in terraform"
}

variable "var_filecontent" {
    default = 3.14
    type = number
    # types of variables are string, number, bool, list(),map()
    description = "Contents of this file are created using terraform variables" 
}

variable "var_filename_list" {
    type = list
    description = "This is a list of filenames to create with 'count' meta argument"
    default = [
        "alpha",
        "beta",
      "gamma",
      "theta"       # Note, since count = 3, this will be ignored by TF. However if I had only say alpha and beta, TF would complain
    ]
}

variable "var_filename_list_2" {
    type = list
    description = "This is a list of filenames to create with 'count' meta argument when used with length() function to auto read count"
    default = [
        "kappa",
        "delta",
        "zeta",
        "epsilon"
    ]
}