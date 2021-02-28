import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labjobfeature/house/house.dart';
import 'package:labjobfeature/house/screens/house_list.dart';

class AddUpdateHouse extends StatefulWidget {
  static const routeName = 'houseAddUpdate';
  final HouseArgument args;

  AddUpdateHouse({this.args});
  @override
  _AddUpdateHouseState createState() => _AddUpdateHouseState();
}

class _AddUpdateHouseState extends State<AddUpdateHouse> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _house = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black87,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text('${widget.args.edit ? "Edit House" : "Add New House"}',
          style: TextStyle(fontSize: 18.0, color: Colors.black87),
        ),
      ),
      body: Padding(
          padding: EdgeInsets.only(left: 20,right: 20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                      initialValue:
                          widget.args.edit ? widget.args.house.title : '',
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter house title';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'title',border:OutlineInputBorder()),
                      onSaved: (value) {
                        setState(() {
                          this._house["title"] = value;
                        });
                      }),
                  SizedBox(height: 20,),
                  TextFormField(
                      initialValue:
                      widget.args.edit ? widget.args.house.bedrooms : '',
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter house bedrooms';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'bedrooms',border:OutlineInputBorder()),
                      onSaved: (value) {
                        setState(() {
                          this._house["bedrooms"] = value;
                        });
                      }),
                  SizedBox(height: 20,),
                  TextFormField(
                      initialValue:
                      widget.args.edit ? widget.args.house.bathrooms : '',
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter house bathrooms';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'bathrooms',border:OutlineInputBorder()),
                      onSaved: (value) {
                        setState(() {
                          this._house["bathrooms"] = value;
                        });
                      }),
                  SizedBox(height: 20,),
                  TextFormField(
                      initialValue:
                      widget.args.edit ? widget.args.house.cost : '',
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter house cost';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'cost',border:OutlineInputBorder()),
                      onSaved: (value) {
                        setState(() {
                          this._house["cost"] = value;
                        });
                      }),
                  SizedBox(height: 20,),
                  TextFormField(
                      initialValue:
                      widget.args.edit ? widget.args.house.street : '',
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter street';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'street',border:OutlineInputBorder()),
                      onSaved: (value) {
                        setState(() {
                          this._house["street"] = value;
                        });
                      }),
                  SizedBox(height: 20,),
                  TextFormField(
                      initialValue:
                      widget.args.edit ? widget.args.house.city : '',
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter house city';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'city',border:OutlineInputBorder()),
                      onSaved: (value) {
                        setState(() {
                          this._house["city"] = value;
                        });
                      }),
                  SizedBox(height: 20,),
                  TextFormField(
                      initialValue:
                      widget.args.edit ? widget.args.house.location : '',
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter house location';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'location',border:OutlineInputBorder()),
                      onSaved: (value) {
                        setState(() {
                          this._house["location"] = value;
                        });
                      }),
                  SizedBox(height: 20,),
                  TextFormField(
                      initialValue:
                          widget.args.edit ? widget.args.house.category : '',
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter house category';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'category',border:OutlineInputBorder()),
                      onSaved: (value) {
                        setState(() {
                          this._house["category"] = value;
                        });
                      }),
                  SizedBox(height: 20,),
                  TextFormField(
                      initialValue:
                          widget.args.edit ? widget.args.house.status : '',
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter house status';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'status',border:OutlineInputBorder()),
                      onSaved: (value) {
                        setState(() {
                          this._house["status"] = value;
                        });
                      }),
                  SizedBox(height: 20,),
                  TextFormField(
                      minLines:
                      3, // any number you need (It works as the rows for the textarea)
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      initialValue:
                          widget.args.edit ? widget.args.house.description : '',
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter house description';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'description',border:OutlineInputBorder()),
                      onSaved: (value) {
                        setState(() {
                          this._house["description"] = value;
                        });
                      }),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final form = _formKey.currentState;
                        if (form.validate()) {
                          form.save();
                          final HouseEvent event = widget.args.edit
                              ? HouseUpdate(
                                  House(
                                    title: this._house["title"],
                                    bedrooms: this._house["bedrooms"],
                                    bathrooms: this._house["bathrooms"],
                                    category: this._house["category"],
                                    status: this._house["status"],
                                    cost: this._house["cost"],
                                    street: this._house["street"],
                                    city: this._house["city"],
                                    location: this._house["location"],
                                    description: this._house["description"],
                                  ),
                                )
                              : HouseCreate(
                                  House(
                                      title: this._house["title"],
                                      bedrooms: this._house["bedrooms"],
                                      bathrooms: this._house["bathrooms"],
                                      category: this._house["category"],
                                      status: this._house["status"],
                                      cost: this._house["cost"],
                                      street: this._house["street"],
                                      city: this._house["city"],
                                      location: this._house["location"],
                                      description: this._house["description"],
                                  ),
                                );
                          BlocProvider.of<HouseBloc>(context).add(event);
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              HouseList.routeName, (route) => false);
                        }
                      },
                      label: Text('SAVE'),
                      icon: Icon(Icons.save),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
